-- SetupConfig: {}
create view CK.vActorPhoneNumber
as
    select
        ActorId = n.ActorId,
        IsPrimary = n.IsPrimary,
        ValTime = n.ValTime,
        PrefixId = n.PrefixId,
        RawPhoneNumber = n.PhoneNumber,
        CountryCodeId = c.PrefixId,
        CountryCode = c.Iso3166Name,
        Prefix = isnull( r1.PhoneNumberPrefix, r2.PhoneNumberPrefix ),
        PhoneNumber = case when n.PhoneNumber is null then null
                           else concat( isnull( r1.PhoneNumberPrefix, r2.PhoneNumberPrefix ), n.PhoneNumber ) end
    from CK.tActorPhoneNumber n
        left outer join CK.tRegionCallingCode r1 on r1.PrefixId = n.PrefixId
        left outer join CK.tCountryCallingCode c on c.PrefixId = n.PrefixId
        left outer join CK.tRegionCallingCode r2 on r2.PrefixId = c.RegionPrefixId;
