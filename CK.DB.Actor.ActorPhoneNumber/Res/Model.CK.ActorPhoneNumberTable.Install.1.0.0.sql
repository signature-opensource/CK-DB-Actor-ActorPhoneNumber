--[beginscript]

create table CK.tActorPhoneNumber
(
	ActorId int not null,
	PhoneNumber varchar( 32 ) collate Latin1_General_100_CI_AS not null,
	IsPrimary bit not null,
	ValTime datetime2( 2 ) not null,
	constraint PK_CK_tActorPhoneNumber primary key( ActorId,PhoneNumber ),
	constraint FK_CK_tActorPhoneNumber_ActorId foreign key( ActorId ) references CK.tActor( ActorId )
);

-- This CK.DB.Actor.ActorPhoneNumber package has been designed so that the same phone number MAY
-- be associated to different actors: by deleting this unique constraint, it is possible to support
-- such scenarii where a phone number can be shared by different actors.
-- Here, we restrict this: by default a phone number is bound to one and only one user.
alter table CK.tActorPhoneNumber add constraint UK_CK_tActorPhoneNumber_PhoneNumber unique nonclustered( PhoneNumber );

--[endscript]
