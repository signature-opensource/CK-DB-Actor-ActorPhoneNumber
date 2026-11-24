Implements the `CK.tActorPhoneNumber` table: the phone numbers of users and groups with their calling code prefix and
validation time, one of them being the primary one. By default a phone number belongs to a single actor.

`ActorPhoneNumberTable` adds, removes and validates the phone numbers (`ActorPhoneNumberTable.AddPhoneNumberAsync`,
`ActorPhoneNumberTable.RemovePhoneNumberAsync`, `ActorPhoneNumberTable.ValidatePhoneNumberAsync`). The prefixes are the
region and country calling codes (`CK.tRegionCallingCode`, `CK.tCountryCallingCode`); the `CK.vActorPhoneNumber` view
gives the full phone numbers, and `CK.vUser` and `CK.vGroup` expose the primary one.

The unicity of a phone number is the `TR_CK_tActorPhoneNumber_UniquePhoneNumber` trigger: dropping it lets the same
phone number be shared by different actors.
