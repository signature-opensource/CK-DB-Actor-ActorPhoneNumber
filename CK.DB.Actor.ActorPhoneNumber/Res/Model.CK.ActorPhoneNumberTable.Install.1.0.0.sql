--[beginscript]

create table CK.tPhoneNumberPrefix
(
    PrefixId int identity(0, 1),

    constraint PK_CK_tPhoneNumberPrefix primary key clustered( PrefixId )
);

insert into CK.tPhoneNumberPrefix default values;

create table CK.tRegionCallingCode
(
    PrefixId int,
    PhoneNumberPrefix varchar( 4 ) collate Latin1_General_100_CI_AS not null,

    constraint PK_CK_tRegionCallingCode primary key clustered( PrefixId ),
    constraint FK_CK_tRegionCallingCode_PrefixId foreign key( PrefixId ) references CK.tPhoneNumberPrefix( PrefixId )
);

create table CK.tCountryCallingCode
(
    PrefixId int,
    Iso3166Name varchar( 2 ) collate Latin1_General_100_CI_AS not null,
    RegionPrefixId int not null,

    constraint PK_CK_tCountryCallingCode primary key clustered( PrefixId ),
    constraint FK_CK_tCountryCallingCode_PrefixId foreign key( PrefixId ) references CK.tPhoneNumberPrefix( PrefixId ),
    constraint FK_CK_tCountryCallingCode_RegionPrefixId foreign key( RegionPrefixId ) references CK.tRegionCallingCode( PrefixId ),
    constraint UK_CK_tCountryCallingCode_Iso3166Name unique( Iso3166Name, RegionPrefixId )
);

create index IX_CK_tCountryCallingCode_RegionPrefixId on CK.tCountryCallingCode( RegionPrefixId );

create table CK.tActorPhoneNumber
(
	ActorId int not null,
    PrefixId int not null,
	PhoneNumber varchar( 16 ) collate Latin1_General_100_CI_AS not null,
	IsPrimary bit not null,
	ValTime datetime2( 2 ) not null,

	constraint PK_CK_tActorPhoneNumber primary key( ActorId, PrefixId, PhoneNumber ),
	constraint FK_CK_tActorPhoneNumber_ActorId foreign key( ActorId ) references CK.tActor( ActorId ),
    constraint FK_CK_tActorPhoneNumber_PrefixId foreign key( PrefixId ) references CK.tPhoneNumberPrefix( PrefixId )
);

create index IX_CK_tActorPhoneNumber_PrefixId on CK.tActorPhoneNumber( PrefixId );
create index IX_CK_tActorPhoneNumber_PhoneNumber on CK.tActorPhoneNumber( PhoneNumber );

--[endscript]
go

-- This CK.DB.Actor.ActorPhoneNumber package has been designed so that the same phone number MAY
-- be associated to different actors: by deleting this trigger, it is possible to support
-- such scenarii where a phone number can be shared by different actors.
-- Here, we restrict this: by default a phone number is bound to one and only one user.
create trigger CK.TR_CK_tActorPhoneNumber_UniquePhoneNumber
on CK.tActorPhoneNumber
after insert, update
as
begin
    if exists( select 1
               from inserted i
                   inner join CK.tActorPhoneNumber p on p.PrefixId = i.PrefixId and p.PhoneNumber = i.PhoneNumber and p.ActorId <> i.ActorId
               union
               select 1
               from CK.tActorPhoneNumber n
                   inner join CK.tCountryCallingCode c on c.PrefixId = n.PrefixId
                   inner join inserted i on i.PrefixId = c.RegionPrefixId and i.PhoneNumber = n.PhoneNumber and i.ActorId <> n.ActorId
               union
               select 1
               from CK.tActorPhoneNumber n
                   inner join CK.tRegionCallingCode r on r.PrefixId = n.PrefixId
                   inner join CK.tCountryCallingCode c on c.RegionPrefixId = r.PrefixId
                   inner join inserted i on i.PrefixId = c.PrefixId and i.PhoneNumber = n.PhoneNumber and i.ActorId <> n.ActorId )
        throw 50000, 'PhoneNumber.NonUnique', 1;
end;


