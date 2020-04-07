-- SetupConfig: { "Requires": [ "CK.sActorPhoneNumberAdd", "CK.vActorPhoneNumber" ] }
--
-- Removes a phone number.
-- Removing an unexisting phone number is silently ignored.
-- When the removed phone number is the primary one, the most recently validated phone number becomes
-- the new primary one.
-- By default, this procedure allows the removal of the only actor's phone number.
--
create procedure CK.sActorPhoneNumberRemove
(
	@ActorId int,
	@UserOrGroupId int,
	@PhoneNumber varchar( 32 )
)
as
begin
    if @ActorId <= 0 throw 50000, 'Security.AnonymousNotAllowed', 1;
	if @PhoneNumber is null throw 50000, 'Argument.NullPhoneNumber', 1;
	set @PhoneNumber = rtrim( ltrim( @PhoneNumber ) );
	if len( @PhoneNumber ) = 0 throw 50000, 'Argument.EmptyPhoneNumber', 1;

	--[beginsp]

	declare @IsPrimary bit;
    declare @PrefixId int;
    declare @RawPhoneNumber varchar( 32 );
	select @IsPrimary = IsPrimary, @PrefixId = PrefixId, @RawPhoneNumber = RawPhoneNumber
    from CK.vActorPhoneNumber
    where ActorId = @UserOrGroupId and PhoneNumber = @PhoneNumber;

	if @IsPrimary is not null
	begin
		--<PreDelete revert />
		delete CK.tActorPhoneNumber where ActorId = @UserOrGroupId and PrefixId = @PrefixId and PhoneNumber = @RawPhoneNumber;
		if @IsPrimary = 1
		begin
			declare @SetNewPrimary bit;
            declare @IsPrefixed bit;
            declare @CountryCodeId int;
			select top 1
                @PhoneNumber = PhoneNumber,
                @IsPrefixed = case when PrefixId = 0 then 0 else 1 end,
                @CountryCodeId = CountryCodeId
            from CK.vActorPhoneNumber
            where ActorId = @UserOrGroupId order by ValTime desc;

			if @@RowCount = 1 set @SetNewPrimary = 1 else set @SetNewPrimary = 0;
			-- Injected code here may decide to throw if @SetNewPrimary is 0
			-- if a primary phone number must always exist ( this check may also be done in PreDelete above ).		
			--<PreSetNewPrimary revert />
			if @SetNewPrimary = 1
			begin
				exec CK.sActorPhoneNumberAdd @ActorId, @UserOrGroupId, @PhoneNumber, @IsPrimary = 1, @IsPrefixed = @IsPrefixed, @CountryCodeId = @CountryCodeId;
			end
			--<PostSetNewPrimary />
		end
		--<PostDelete />
	end

	
	--[endsp]
end

