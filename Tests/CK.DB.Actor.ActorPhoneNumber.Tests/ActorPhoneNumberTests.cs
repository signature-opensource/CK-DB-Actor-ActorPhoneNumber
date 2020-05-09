using System;
using System.Data.SqlClient;
using System.Linq;
using CK.Core;
using CK.SqlServer;
using FluentAssertions;
using NUnit.Framework;
using static CK.Testing.DBSetupTestHelper;

namespace CK.DB.Actor.ActorPhoneNumber.Tests
{
    [TestFixture]
    public class ActorPhoneNumberTests
    {
        [Test]
        public void adding_and_removing_one_phone_number_to_System()
        {
            var phoneNumbers = TestHelper.StObjMap.StObjs.Obtain<ActorPhoneNumberTable>();
            using( var ctx = new SqlStandardCallContext( TestHelper.Monitor ) )
            {
                phoneNumbers.Database.ExecuteScalar( "select PrimaryPhoneNumber from CK.vUser where UserId=1" )
                        .Should().Be( DBNull.Value );

                phoneNumbers.AddPhoneNumber( ctx, 1, 1, "33123456789", false );
                phoneNumbers.Database.ExecuteScalar( "select PrimaryPhoneNumber from CK.vUser where UserId=1" )
                        .Should().Be( "33123456789" );

                phoneNumbers.RemovePhoneNumber( ctx, 1, 1, "33123456789" );
                phoneNumbers.Database.ExecuteScalar( "select PrimaryPhoneNumber from CK.vUser where UserId=1" )
                        .Should().Be( DBNull.Value );
            }
        }

        [Test]
        public void first_phone_number_is_automatically_primary_but_the_first_valid_one_is_elected()
        {
            var group = TestHelper.StObjMap.StObjs.Obtain<GroupTable>();
            var phoneNumbers = TestHelper.StObjMap.StObjs.Obtain<ActorPhoneNumberTable>();
            using( var ctx = new SqlStandardCallContext( TestHelper.Monitor ) )
            {
                var gId = group.CreateGroup( ctx, 1 );
                phoneNumbers.AddPhoneNumber( ctx, 1, gId, "33123456789", false );
                phoneNumbers.Database.ExecuteScalar( $"select PrimaryPhoneNumber from CK.vGroup where GroupId={gId}" )
                    .Should().Be( "33123456789" );

                phoneNumbers.AddPhoneNumber( ctx, 1, gId, "33687654321", false );
                phoneNumbers.Database.ExecuteScalar( $"select PrimaryPhoneNumber from CK.vGroup where GroupId={gId}" )
                    .Should().Be( "33123456789" );

                phoneNumbers.AddPhoneNumber( ctx, 1, gId, "33000000000", false );
                phoneNumbers.Database.ExecuteScalar( $"select PrimaryPhoneNumber from CK.vGroup where GroupId={gId}" )
                    .Should().Be( "33123456789" );


                phoneNumbers.ValidatePhoneNumber( ctx, 1, gId, "33687654321" );
                phoneNumbers.Database.ExecuteScalar( $"select PrimaryPhoneNumber from CK.vGroup where GroupId={gId}" )
                    .Should().Be( "33687654321" );

                group.DestroyGroup( ctx, 1, gId );
            }
        }

        [Test]
        public void when_removing_the_primary_phone_number_another_one_is_elected_even_if_they_are_all_not_validated()
        {
            var user = TestHelper.StObjMap.StObjs.Obtain<UserTable>();
            var phoneNumbers = TestHelper.StObjMap.StObjs.Obtain<ActorPhoneNumberTable>();
            using( var ctx = new SqlStandardCallContext( TestHelper.Monitor ) )
            {
                var uId = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId, "33123456789", false );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId, "33223456789", false );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId, "33323456789", true );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId, "33423456789", false );
                phoneNumbers.Database.ExecuteScalar( $"select PrimaryPhoneNumber from CK.vUser where UserId={uId}" )
                    .Should().Be( "33323456789" );

                phoneNumbers.RemovePhoneNumber( ctx, 1, uId, "33323456789" );
                phoneNumbers.Database.ExecuteScalar<string>( $"select PrimaryPhoneNumber from CK.vUser where UserId={uId}" )
                    .Should().Match( m => m == "33123456789" || m == "33223456789" || m == "33423456789" );
                user.DestroyUser( ctx, 1, uId );
            }
        }

        [Test]
        public void PhoneNumber_unicity_can_be_dropped_if_needed()
        {
            var user = TestHelper.StObjMap.StObjs.Obtain<UserTable>();
            var phoneNumbers = TestHelper.StObjMap.StObjs.Obtain<ActorPhoneNumberTable>();
            using( var ctx = new SqlStandardCallContext( TestHelper.Monitor ) )
            {
                // We need a connection that stays Opened because we are playing with begin tran/rollback accross queries.
                ctx[phoneNumbers.Database].PreOpen();

                var uniquePhoneNumber = UniqueLocalPhoneNumber().Substring( 0, 9 );
                var uId1 = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId1, uniquePhoneNumber + "1", isPrimary: false ).Should().Be( uId1, "The 1 is the primary phone number." );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId1, uniquePhoneNumber + "0", false ).Should().Be( uId1 );
                phoneNumbers.Database.ExecuteScalar<string>( $"select PrimaryPhoneNumber from CK.vUser where UserId={uId1}" ).Should().Be( uniquePhoneNumber + "1" );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId1, uniquePhoneNumber + "0", true ).Should().Be( uId1, "Change the primary!" );
                phoneNumbers.Database.ExecuteScalar<string>( $"select PrimaryPhoneNumber from CK.vUser where UserId={uId1}" ).Should().Be( uniquePhoneNumber + "0" );
                phoneNumbers.Database.ExecuteScalar<int>( $"select count(*) from CK.tActorPhoneNumber where ActorId={uId1}" ).Should().Be( 2 );

                var uId2 = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber + "2", false ).Should().Be( uId2, "The 2 is the primary phone number." );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber + "0", true ).Should().Be( uId1, "Another user => the first user id is returned and nothing is done." );
                // Nothing changed for both user.
                phoneNumbers.Database.ExecuteScalar<string>( $"select PrimaryPhoneNumber from CK.vUser where UserId={uId1}" ).Should().Be( uniquePhoneNumber + "0" );
                phoneNumbers.Database.ExecuteScalar<string>( $"select PrimaryPhoneNumber from CK.vUser where UserId={uId2}" ).Should().Be( uniquePhoneNumber + "2" );
                phoneNumbers.Database.ExecuteScalar<int>( $"select count(*) from CK.tActorPhoneNumber where ActorId={uId2}" ).Should().Be( 1 );

                // Calling with avoidAmbiguousPhoneNumber = false: behavior depends on TR_CK_tActorPhoneNumber_UniquePhoneNumber constraint.
                bool isUnique = phoneNumbers.Database.ExecuteScalar( "select object_id('CK.TR_CK_tActorPhoneNumber_UniquePhoneNumber', 'TR')" ) != DBNull.Value;
                if( isUnique )
                {
                    TestHelper.Monitor.Info( "CK.TR_CK_tActorPhoneNumber_UniquePhoneNumber constraint found: PhoneNumber cannot be shared among users." );
                    // We cannot use the Database helpers here since the use a brand new SqlConnection each time.
                    // We must use the SqlCallContext.
                    phoneNumbers.Invoking( m => m.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber + "0", true, avoidAmbiguousPhoneNumber: false ) ).Should().Throw<SqlDetailedException>();
                    using( Util.CreateDisposableAction( () => ctx[phoneNumbers.Database].ExecuteNonQuery( new SqlCommand( "rollback;" ) ) ) )
                    {
                        ctx[phoneNumbers.Database].ExecuteNonQuery( new SqlCommand( "begin tran; drop trigger CK.TR_CK_tActorPhoneNumber_UniquePhoneNumber;" ) );
                        TestWithoutUnicityConstraint( phoneNumbers, ctx, uniquePhoneNumber + "0", uId2 );
                    }
                }
                else
                {
                    TestHelper.Monitor.Info( "CK.TR_CK_tActorPhoneNumber_UniquePhoneNumber constraint NOT found: PhoneNumber can be shared among users." );
                    TestWithoutUnicityConstraint( phoneNumbers, ctx, uniquePhoneNumber + "0", uId2 );
                    // We cannot test the unicity behavior here since applying the constraint will fail if current multiple phone numbers exist.
                }

                static void TestWithoutUnicityConstraint( ActorPhoneNumberTable phoneNumbers, SqlStandardCallContext ctx, string uniquePhoneNumber, int uId2 )
                {
                    phoneNumbers.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber, true, avoidAmbiguousPhoneNumber: false ).Should().Be( uId2 );
                    ctx[phoneNumbers.Database].ExecuteScalar( new SqlCommand( $"select count(*) from CK.tActorPhoneNumber where ActorId={uId2}" ) ).Should().Be( 2 );
                    ctx[phoneNumbers.Database].ExecuteScalar( new SqlCommand( $"select count(*) from CK.tActorPhoneNumber where PhoneNumber='{uniquePhoneNumber}'" ) ).Should().Be( 2 );
                }

            }
        }

        [Test]
        public void when_removing_the_primary_phone_number_the_most_recently_validated_is_elected()
        {
            var user = TestHelper.StObjMap.StObjs.Obtain<UserTable>();
            var phoneNumbers = TestHelper.StObjMap.StObjs.Obtain<ActorPhoneNumberTable>();
            using( var ctx = new SqlStandardCallContext( TestHelper.Monitor ) )
            {
                var uId = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );
                for( int i = 0; i < 10; i++ )
                {
                    phoneNumbers.AddPhoneNumber( ctx, 1, uId, $"3312345678{i}", false, true );
                }
                phoneNumbers.AddPhoneNumber( ctx, 1, uId, "33223456789", false );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId, "33323456789", true );
                System.Threading.Thread.Sleep( 100 );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId, "33423456789", false, true );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId, "33523456789", false );
                phoneNumbers.Database.ExecuteScalar( $"select PrimaryPhoneNumber from CK.vUser where UserId={uId}" );
                phoneNumbers.RemovePhoneNumber( ctx, 1, uId, "33323456789" );
                phoneNumbers.Database.ExecuteScalar( $"select PrimaryPhoneNumber from CK.vUser where UserId={uId}" );
                user.DestroyUser( ctx, 1, uId );
            }
        }

        [Test]
        public void adding_and_removing_phone_number_with_prefix()
        {
            var user = TestHelper.StObjMap.StObjs.Obtain<UserTable>();
            var phoneNumbers = TestHelper.StObjMap.StObjs.Obtain<ActorPhoneNumberTable>();
            string uniquePhoneNumber = UniqueInternationalPhoneNumber();
            using( var ctx = new SqlStandardCallContext( TestHelper.Monitor ) )
            {
                var uId = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );
                phoneNumbers.Database.ExecuteScalar( "select PrimaryPhoneNumber from CK.vUser where UserId = @0;", uId )
                        .Should().Be( DBNull.Value );

                phoneNumbers.AddPhoneNumber( ctx, 1, uId, uniquePhoneNumber, false, isPrefixed: true );
                phoneNumbers.Database.ExecuteScalar(
                    @"select count(*)
                      from CK.vUser
                      where UserId = @0
                        and PrimaryPhoneNumber = @1
                        and PrimaryPhoneNumberPrefix = @2
                        and PrimaryPhoneNumberCountryCode is null
                        and PrimaryRawPhoneNumber = @3;",
                    uId, uniquePhoneNumber, "33", uniquePhoneNumber.Substring( 2 ) )
                        .Should().Be( 1 );

                phoneNumbers.RemovePhoneNumber( ctx, 1, uId, uniquePhoneNumber );
                phoneNumbers.Database.ExecuteScalar( "select PrimaryPhoneNumber from CK.vUser where UserId = @0;", uId )
                        .Should().Be( DBNull.Value );

                user.DestroyUser( ctx, 1, uId );
            }
        }

        [Test]
        public void adding_and_removing_phone_number_with_prefix_and_country_code()
        {
            var user = TestHelper.StObjMap.StObjs.Obtain<UserTable>();
            var phoneNumbers = TestHelper.StObjMap.StObjs.Obtain<ActorPhoneNumberTable>();
            string uniquePhoneNumber = UniqueInternationalPhoneNumber();
            using( var ctx = new SqlStandardCallContext( TestHelper.Monitor ) )
            {
                var uId = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );
                const string countryCode = "FR";

                phoneNumbers.AddPhoneNumber( ctx, 1, uId, uniquePhoneNumber, false, isPrefixed: true, countryCode: countryCode );
                phoneNumbers.Database.ExecuteScalar(
                    @"select count(*)
                      from CK.vUser
                      where UserId = @0
                        and PrimaryPhoneNumber = @1
                        and PrimaryPhoneNumberPrefix = @2
                        and PrimaryPhoneNumberCountryCode = @3
                        and PrimaryRawPhoneNumber = @4;",
                    uId, uniquePhoneNumber, "33", countryCode, uniquePhoneNumber.Substring( 2 ) )
                        .Should().Be( 1 );

                phoneNumbers.RemovePhoneNumber( ctx, 1, uId, uniquePhoneNumber );
                phoneNumbers.Database.ExecuteScalar( "select PrimaryPhoneNumber from CK.vUser where UserId = @0;", uId )
                        .Should().Be( DBNull.Value );

                user.DestroyUser( ctx, 1, uId );
            }
        }

        [Test]
        public void adding_and_removing_phone_number_with_country_code()
        {
            var user = TestHelper.StObjMap.StObjs.Obtain<UserTable>();
            var phoneNumbers = TestHelper.StObjMap.StObjs.Obtain<ActorPhoneNumberTable>();
            string uniquePhoneNumber = UniqueInternationalPhoneNumber().Substring( 2 );
            using( var ctx = new SqlStandardCallContext( TestHelper.Monitor ) )
            {
                var uId = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );
                const string countryCode = "FR";

                phoneNumbers.AddPhoneNumber( ctx, 1, uId, uniquePhoneNumber, false, isPrefixed: false, countryCode: countryCode );
                phoneNumbers.Database.ExecuteScalar(
                    @"select count(*)
                      from CK.vUser
                      where UserId = @0
                        and PrimaryPhoneNumber = @1
                        and PrimaryPhoneNumberPrefix = @2
                        and PrimaryPhoneNumberCountryCode = @3
                        and PrimaryRawPhoneNumber = @4;",
                    uId, "33" + uniquePhoneNumber, "33", countryCode, uniquePhoneNumber )
                        .Should().Be( 1 );

                phoneNumbers.RemovePhoneNumber( ctx, 1, uId, "33" + uniquePhoneNumber );
                phoneNumbers.Database.ExecuteScalar( "select PrimaryPhoneNumber from CK.vUser where UserId = @0;", uId )
                        .Should().Be( DBNull.Value );

                user.DestroyUser( ctx, 1, uId );
            }
        }

        [Test]
        public void phone_number_unicity()
        {
            var user = TestHelper.StObjMap.StObjs.Obtain<UserTable>();
            var phoneNumbers = TestHelper.StObjMap.StObjs.Obtain<ActorPhoneNumberTable>();
            string uniquePhoneNumber1 = UniqueInternationalPhoneNumber();
            string uniquePhoneNumber2 = UniqueInternationalPhoneNumber();
            string uniquePhoneNumber3 = UniqueInternationalPhoneNumber();
            using( var ctx = new SqlStandardCallContext( TestHelper.Monitor ) )
            {
                var uId1 = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );
                var uId2 = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );
                var uId3 = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );

                phoneNumbers.AddPhoneNumber( ctx, 1, uId1, uniquePhoneNumber1, false, isPrefixed: true )
                    .Should().Be( uId1 );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber2, false, isPrefixed: true, countryCode: "FR" )
                    .Should().Be( uId2 );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId3, uniquePhoneNumber3, false, isPrefixed: false )
                    .Should().Be( uId3 );

                phoneNumbers.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber1, false, isPrefixed: true )
                    .Should().Be( uId1 );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber1, false, isPrefixed: true, countryCode: "FR" )
                    .Should().Be( uId1 );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber1.Substring( 2 ), false, countryCode: "FR" )
                    .Should().Be( uId1 );

                phoneNumbers.AddPhoneNumber( ctx, 1, uId1, uniquePhoneNumber2, false, isPrefixed: true, countryCode: "FR" )
                    .Should().Be( uId2 );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId1, uniquePhoneNumber2, false, isPrefixed: true )
                    .Should().Be( uId2 );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId1, uniquePhoneNumber2.Substring( 2 ), false, countryCode: "FR" )
                    .Should().Be( uId2 );

                phoneNumbers.AddPhoneNumber( ctx, 1, uId1, uniquePhoneNumber3, false )
                    .Should().Be( uId3 );

                phoneNumbers.RemovePhoneNumber( ctx, 1, uId1, uniquePhoneNumber1 );
                phoneNumbers.RemovePhoneNumber( ctx, 1, uId2, uniquePhoneNumber2 );
                phoneNumbers.RemovePhoneNumber( ctx, 1, uId3, uniquePhoneNumber3 );
                user.DestroyUser( ctx, 1, uId1 );
                user.DestroyUser( ctx, 1, uId2 );
                user.DestroyUser( ctx, 1, uId3 );
            }
        }

        [Test]
        public void phone_number_unicity_when_avoid_ambiguous_phone_number()
        {
            var user = TestHelper.StObjMap.StObjs.Obtain<UserTable>();
            var phoneNumbers = TestHelper.StObjMap.StObjs.Obtain<ActorPhoneNumberTable>();
            string uniquePhoneNumber = UniqueInternationalPhoneNumber();
            using( var ctx = new SqlStandardCallContext( TestHelper.Monitor ) )
            {
                var uId1 = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );
                var uId2 = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );

                phoneNumbers.AddPhoneNumber( ctx, 1, uId1, uniquePhoneNumber, false, isPrefixed: true );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId1, uniquePhoneNumber, false, isPrefixed: true )
                    .Should().Be( uId1 );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber, false, isPrefixed: true )
                    .Should().Be( uId1 );
                const string countryCode = "FR";
                phoneNumbers.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber, false, isPrefixed: true, countryCode: countryCode )
                    .Should().Be( uId1 );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber.Substring( 2 ), false, countryCode: countryCode )
                    .Should().Be( uId1 );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber, false )
                    .Should().Be( uId2 );

                phoneNumbers.RemovePhoneNumber( ctx, 1, uId1, uniquePhoneNumber );
                user.DestroyUser( ctx, 1, uId1 );
                user.DestroyUser( ctx, 1, uId2 );
            }
        }

        [Test]
        public void phone_number_unicity_when_don_t_avoid_ambiguous_phone_number()
        {
            var user = TestHelper.StObjMap.StObjs.Obtain<UserTable>();
            var phoneNumbers = TestHelper.StObjMap.StObjs.Obtain<ActorPhoneNumberTable>();
            string uniquePhoneNumber = UniqueInternationalPhoneNumber();
            using( var ctx = new SqlStandardCallContext( TestHelper.Monitor ) )
            {
                var uId1 = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );
                var uId2 = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );

                phoneNumbers.AddPhoneNumber( ctx, 1, uId1, uniquePhoneNumber, false, isPrefixed: true, avoidAmbiguousPhoneNumber: false );
                phoneNumbers.Invoking( p => p.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber, false, isPrefixed: true, avoidAmbiguousPhoneNumber: false ) )
                    .Should().Throw<Exception>();
                const string countryCode = "FR";
                phoneNumbers.Invoking( p => p.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber, false, isPrefixed: true, countryCode: countryCode, avoidAmbiguousPhoneNumber: false ) )
                    .Should().Throw<Exception>();
                phoneNumbers.Invoking( p => p.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber.Substring( 2 ), false, countryCode: countryCode, avoidAmbiguousPhoneNumber: false ) )
                    .Should().Throw<Exception>();
                phoneNumbers.Invoking( p => p.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber, false, avoidAmbiguousPhoneNumber: false ) )
                    .Should().NotThrow<Exception>();

                phoneNumbers.RemovePhoneNumber( ctx, 1, uId1, uniquePhoneNumber );
                user.DestroyUser( ctx, 1, uId1 );
                user.DestroyUser( ctx, 1, uId2 );
            }
        }

        static string UniqueLocalPhoneNumber() => UniquePhoneNumber( "0123" );

        static string UniqueInternationalPhoneNumber() => UniquePhoneNumber( "33123" );

        static string UniquePhoneNumber( string prefix )
        {
            string suffix = Guid.NewGuid()
                .ToByteArray()
                .Take( 2 )
                .Select( b => Convert.ToString( b, 8 ).PadLeft( 3, '0' ) )
                .Aggregate( ( s1, s2 ) => $"{s1}{s2}" );
            return $"{prefix}{suffix}";
        }
    }
}
