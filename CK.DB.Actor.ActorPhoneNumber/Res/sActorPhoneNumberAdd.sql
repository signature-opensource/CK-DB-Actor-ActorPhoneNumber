-- SetupConfig: { }
--
-- Adds a phone number to a user or a group and/or sets whether it is the primary one.
-- Optionally sets the ValTime to sysutcdatetime() or '0001-01-01'.
-- By default @AvoidAmbiguousPhoneNumber is set to 1 so that if the phone number already exists for another user,
-- nothing is done and the actor identifier that is bound to the PhoneNumber is returned in @UserOrGroupId parameter.
--
-- When @AvoidAmbiguousPhoneNumber is 0, the behavior depends on the unicity of the PhoneNumber column:
--   - if the unique key exists (teh default), a duplicate key error will be raised.
--   - if no unique key is defined (ie. the UK_CK_tActorPhoneNumber_PhoneNumber constraint has been dropped),
--     the same phone number can be associated to different users.
--
create procedure CK.sActorPhoneNumberAdd 
(
	@ActorId int,
	@UserOrGroupId int /*input*/output,
	@PhoneNumber varchar( 32 ),
	@IsPrimary bit,
	@Validate bit = null,
    @AvoidAmbiguousPhoneNumber bit = 1,
    @IsPrefixed bit = null,
    @CountryCodeId int = null
)
as
begin
    if @ActorId <= 0 throw 50000, 'Security.AnonymousNotAllowed', 1;
	if @PhoneNumber is null throw 50000, 'Argument.NullPhoneNumber', 1;
	set @PhoneNumber = rtrim( ltrim( @PhoneNumber ) );
	if len( @PhoneNumber ) = 0 throw 50000, 'Argument.EmptyPhoneNumber', 1;
	if @IsPrimary is null throw 50000, 'Argument.NullIsPrimary', 1;

    if @IsPrefixed is null set @IsPrefixed = 0;
    if @CountryCodeId is null set @CountryCodeId = 0;

	--[beginsp]

    declare @PrefixId int;
    declare @Prefix varchar( 4 );
    if @IsPrefixed <> 0 and @CountryCodeId = 0
    begin
        select top 1 @PrefixId = c.PrefixId, @Prefix = c.PhoneNumberPrefix
        from CK.tRegionCallingCode c
        where c.PhoneNumberPrefix = left( @PhoneNumber, len( c.PhoneNumberPrefix ) )
        order by len( c.PhoneNumberPrefix ) desc;

        if @PrefixId is null throw 50000, 'PhoneNumber.PrefixNotFound', 1;
        set @PhoneNumber = right( @PhoneNumber, len( @PhoneNumber ) - len( @Prefix )  );
    end
    else if @IsPrefixed <> 0
    begin
        set @PrefixId = @CountryCodeId;
        select @Prefix = r.PhoneNumberPrefix
        from CK.tCountryCallingCode c
            inner join CK.tRegionCallingCode r on r.PrefixId = c.RegionPrefixId
        where c.PrefixId = @PrefixId and charindex( r.PhoneNumberPrefix, @PhoneNumber ) = 1;

        if @Prefix is null throw 50000, 'PhoneNumber.PrefixNotFound', 1;
        set @PhoneNumber = right( @PhoneNumber, len( @PhoneNumber ) - len( @Prefix )  );
    end
    else if @CountryCodeId <> 0
    begin
        if not exists( select 1 from CK.tCountryCallingCode c where c.PrefixId = @CountryCodeId )
            throw 50000, 'PhoneNumber.UnknownCountryCodeId', 1;
        set @PrefixId = @CountryCodeId;
    end
    else
    begin
        set @PrefixId = 0;
    end

    if @AvoidAmbiguousPhoneNumber = 1
    begin
        declare @AlreadyOtherActorId int;
        select @AlreadyOtherActorId = ActorId from CK.tActorPhoneNumber where PrefixId = @PrefixId and PhoneNumber = @PhoneNumber;
        if @AlreadyOtherActorId is not null and @AlreadyOtherActorId <> @UserOrGroupId
        begin           
            --<AmbiguousPhoneNumberDetected />
            set @UserOrGroupId = @AlreadyOtherActorId;
        end
        else
        begin
            set @AvoidAmbiguousPhoneNumber = 0;
        end
    end

    if @AvoidAmbiguousPhoneNumber = 0
    begin
	    declare @ExistingPrimaryPrefixId int;
	    declare @ExistingPrimaryPhoneNumber varchar( 32 );
	    select @ExistingPrimaryPrefixId = PrefixId, @ExistingPrimaryPhoneNumber = PhoneNumber from CK.tActorPhoneNumber where ActorId = @UserOrGroupId and IsPrimary = 1
	    declare @NewPrimaryPrefixId int;
	    declare @NewPrimaryPhoneNumber varchar( 32 );
	    if @ExistingPrimaryPhoneNumber is null set @IsPrimary = 1;
	    if @IsPrimary = 1
        begin
            set @NewPrimaryPrefixId = @PrefixId;
            set @NewPrimaryPhoneNumber = @PhoneNumber;
        end
	    else
        begin
            set @NewPrimaryPrefixId = @ExistingPrimaryPrefixId;
            set @NewPrimaryPhoneNumber = @ExistingPrimaryPhoneNumber;
        end;

	    --<PrePhoneNumberAdd revert />

	    -- Update or insert the @PhoneNumber.
	    merge CK.tActorPhoneNumber as target
		    using( select ActorId = @UserOrGroupId, PrefixId = @PrefixId, PhoneNumber = @PhoneNumber ) 
		    as source on source.ActorId = target.ActorId and source.PrefixId = target.PrefixId and source.PhoneNumber = target.PhoneNumber
		    when matched then update set IsPrimary = @IsPrimary, 
									     ValTime = case when @Validate is null then target.ValTime 
													    when @Validate = 0 then '00010101'
													    else sysutcdatetime() 
												    end
		    when not matched by target then insert( ActorId, PrefixId, PhoneNumber, IsPrimary, ValTime ) 
											    values( @UserOrGroupId,
                                                        @PrefixId,
													    @PhoneNumber, 
													    @IsPrimary, 
													    case when @Validate is null or @Validate = 0 
														    then '00010101'
														    else sysutcdatetime() 
													    end );
	    -- A little bit of defensive programming here: 
	    -- we always reset the IsPrimary bit based on @NewPrimaryPhoneNumber or elect a new one.
	    if @NewPrimaryPhoneNumber is null
	    begin
		    select top 1 @NewPrimaryPhoneNumber = PhoneNumber, @NewPrimaryPrefixId = PrefixId from CK.tActorPhoneNumber where ActorId = @UserOrGroupId order by ValTime desc;
	    end

	    if @NewPrimaryPhoneNumber is not null
	    begin
		    update CK.tActorPhoneNumber 
			    set IsPrimary = case when PhoneNumber = @NewPrimaryPhoneNumber and PrefixId = @NewPrimaryPrefixId then 1 else 0 end 
			    where ActorId = @UserOrGroupId;
	    end

	    --<PostPhoneNumberAdd />
    end
    
	--[endsp]
end

