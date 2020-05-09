using System.Threading.Tasks;
using CK.Core;
using CK.SqlServer;

namespace CK.DB.Actor.ActorPhoneNumber
{
    /// <summary>
    /// Holds phone numbers (among them one is the primary phone number) for a user or a group.
    /// By default, the TR_CK_tActorPhoneNumber_UniquePhoneNumber unique constraint enforces the fact that no PhoneNumber can be shared among actors. 
    /// </summary>
    /// <remarks>
    /// This CK.DB.Actor.ActorPhoneNumber package has been designed so that the same phone number MAY
    /// be associated to different actors: by deleting the TR_CK_tActorPhoneNumber_UniquePhoneNumber unique constraint, it is
    /// possible to support such scenarii where the same phone number can be shared by different actors.
    ///  </remarks>
    [SqlTable( "tActorPhoneNumber", Package = typeof( Package ) )]
    [Versions( "1.0.0" )]
    [SqlObjectItem( "transform:sUserDestroy, transform:sGroupDestroy, transform:vUser, transform:vGroup, vActorPhoneNumber" )]
    public abstract partial class ActorPhoneNumberTable : SqlTable
    {
        /// <summary>
        /// Adds a phone number to a user or a group and/or sets whether it is the primary one.
        /// By default <paramref name="avoidAmbiguousPhoneNumber"/>> is true so that if the phone number already exists for
        /// another user, nothing is done and the actor identifier that is bound to the existing phone number is returned.
        /// When avoidAmbiguousPhoneNumber is false, the behavior depends on the unicity of the (Prefix, PhoneNumber) properties: if the trigger exists (the default),
        /// an error will be raised but if no trigger is defined (ie. the TR_CK_tActorPhoneNumber_UniquePhoneNumber trigger has
        /// been dropped), the same phone number can be associated to different users.
        /// </summary>
        /// <param name="ctx">The call context to use.</param>
        /// <param name="actorId">The acting actor identifier.</param>
        /// <param name="userOrGroupId">The user or group identifier for which a phone number should be added or configured as the primary one.</param>
        /// <param name="phoneNumber">The phone number.</param>
        /// <param name="isPrimary">True to set the phone number as the user or group's primary one.</param>
        /// <param name="validate">Optionaly sets the ValTime of the phone number: true to set it to sysUtcDateTime(), false to reset it to '0001-01-01'.</param>
        /// <param name="avoidAmbiguousPhoneNumber">False to skip phone number unicity check: always attempts to add the phone number to the actor.</param>
        /// <param name="isPrefixed">An optional value indicating whether the <paramref name="phoneNumber"/> is prefixed by a country calling code.</param>
        /// <param name="countryCodeId">The optional country code id (mutually exclusive with <paramref name="countryCode"/>).</param>
        /// <param name="countryCode">The optional country code (mutually exclusive with <paramref name="countryCodeId"/>).</param>
        /// <returns>
        /// The <paramref name="userOrGroupId"/> or, if <paramref name="avoidAmbiguousPhoneNumber"/> is true (the default), the identifier that
        /// is already associated to the phone number.
        /// </returns>
        [SqlProcedure( "sActorPhoneNumberAdd" )]
        public abstract Task<int> AddPhoneNumberAsync( ISqlCallContext ctx, int actorId, int userOrGroupId, string phoneNumber, bool isPrimary, bool? validate = null, bool avoidAmbiguousPhoneNumber = true, bool? isPrefixed = null, int? countryCodeId = null, string countryCode = null );

        /// <summary>
        /// Removes a phone number from the user or group's phone numbers (removing an unexisting phone number is silently ignored).
        /// When the removed phone number is the primary one, the most recently validated phone number becomes
        /// the new primary one.
        /// By default, this procedure allows the removal of the only actor's phone number.
        /// </summary>
        /// <param name="ctx">The call context to use.</param>
        /// <param name="actorId">The acting actor identifier.</param>
        /// <param name="userOrGroupId">The user or group identifier for which a phone number must be removed.</param>
        /// <param name="phoneNumber">The phone number to remove.</param>
        /// <returns>The awaitable.</returns>
        [SqlProcedure( "sActorPhoneNumberRemove" )]
        public abstract Task RemovePhoneNumberAsync( ISqlCallContext ctx, int actorId, int userOrGroupId, string phoneNumber );

        /// <summary>
        /// Validates a phone number by uptating its ValTime to the current sysutdatetime.
        /// Validating a non existing phone number is silently ignored.
        /// If the current primary phone number is not validated, this newly validated phone number becomes
        /// the primary one.
        /// </summary>
        /// <param name="ctx">The call context to use.</param>
        /// <param name="actorId">The acting actor identifier.</param>
        /// <param name="userOrGroupId">The user or group identifier for which the phone number is valid.</param>
        /// <param name="phoneNumber">The phone number to valid.</param>
        /// <returns>The awaitable.</returns>
        [SqlProcedure( "sActorPhoneNumberValidate" )]
        public abstract Task ValidatePhoneNumberAsync( ISqlCallContext ctx, int actorId, int userOrGroupId, string phoneNumber );

    }
}
