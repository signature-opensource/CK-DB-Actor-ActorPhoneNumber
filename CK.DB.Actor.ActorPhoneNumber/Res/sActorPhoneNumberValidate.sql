-- SetupConfig: { "Requires": "CK.sActorPhoneNumberAdd" }
--
-- Validates a phone number by uptating its ValTime to the current sysutdatetime().
-- Validating a non existing phone number is silently ignored.
-- If the current primary phone number is not validated, this newly validated phone number becomes
-- the primary one.
-- 
create procedure CK.sActorPhoneNumberValidate
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

    --<PrePhoneNumberValidate revert />

	update CK.tActorPhoneNumber set ValTime = sysutcdatetime() where ActorId = @UserOrGroupId and PhoneNumber = @PhoneNumber;
	if @@RowCount = 1
	begin
		declare @ExistingPrimaryPhoneNumber varchar( 32 );
		select @ExistingPrimaryPhoneNumber = PhoneNumber 
			from CK.tActorPhoneNumber
			where ActorId = @UserOrGroupId and IsPrimary = 1 and ValTime = '00010101';
		if @ExistingPrimaryPhoneNumber is not null
		begin
			exec CK.sActorPhoneNumberAdd @ActorId, @UserOrGroupId, @PhoneNumber, @IsPrimary = 1; 
		end
	end

	--<PostPhoneNumberValidate />
	
	--[endsp]
end

