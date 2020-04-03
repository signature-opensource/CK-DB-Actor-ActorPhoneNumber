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

                var uniquePhoneNumber = UniquePhoneNumber();
                var uId1 = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId1, uniquePhoneNumber + "1", isPrimary: false ).Should().Be( uId1, "The 1 is the primary phone number." );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId1, uniquePhoneNumber, false ).Should().Be( uId1 );
                phoneNumbers.Database.ExecuteScalar<string>( $"select PrimaryPhoneNumber from CK.vUser where UserId={uId1}" ) .Should().Be( uniquePhoneNumber + "1" );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId1, uniquePhoneNumber, true ).Should().Be( uId1, "Change the primary!" );
                phoneNumbers.Database.ExecuteScalar<string>( $"select PrimaryPhoneNumber from CK.vUser where UserId={uId1}" ).Should().Be( uniquePhoneNumber );
                phoneNumbers.Database.ExecuteScalar<int>( $"select count(*) from CK.tActorPhoneNumber where ActorId={uId1}" ).Should().Be( 2 );

                var uId2 = user.CreateUser( ctx, 1, Guid.NewGuid().ToString() );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber + "2", false ).Should().Be( uId2, "The 2 is the primary phone number." );
                phoneNumbers.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber, true ).Should().Be( uId1, "Another user => the first user id is returned and nothing is done." );
                // Nothing changed for both user.
                phoneNumbers.Database.ExecuteScalar<string>( $"select PrimaryPhoneNumber from CK.vUser where UserId={uId1}" ).Should().Be( uniquePhoneNumber );
                phoneNumbers.Database.ExecuteScalar<string>( $"select PrimaryPhoneNumber from CK.vUser where UserId={uId2}" ).Should().Be( uniquePhoneNumber + "2" );
                phoneNumbers.Database.ExecuteScalar<int>( $"select count(*) from CK.tActorPhoneNumber where ActorId={uId2}" ).Should().Be( 1 );

                // Calling with avoidAmbiguousPhoneNumber = false: behavior depends on UK_CK_tActorPhoneNumber_PhoneNumber constraint.
                bool isUnique = phoneNumbers.Database.ExecuteScalar( "select object_id('CK.UK_CK_tActorPhoneNumber_PhoneNumber', 'UQ')" ) != DBNull.Value;
                if( isUnique )
                {
                    TestHelper.Monitor.Info( "CK.UK_CK_tActorPhoneNumber_PhoneNumber constraint found: PhoneNumber cannot be shared among users." );
                    // We cannot use the Database helpers here since the use a brand new SqlConnection each time.
                    // We must use the SqlCallContext.
                    phoneNumbers.Invoking( m => m.AddPhoneNumber( ctx, 1, uId2, uniquePhoneNumber, true, avoidAmbiguousPhoneNumber:false ) ).Should().Throw<SqlDetailedException>();
                    using( Util.CreateDisposableAction( () => ctx[phoneNumbers.Database].ExecuteNonQuery( new SqlCommand( "rollback;" ) ) ) )
                    {
                        ctx[phoneNumbers.Database].ExecuteNonQuery( new SqlCommand( "begin tran; alter table CK.tActorPhoneNumber drop constraint UK_CK_tActorPhoneNumber_PhoneNumber;" ) );
                        TestWithoutUnicityConstraint( phoneNumbers, ctx, uniquePhoneNumber, uId2 );
                    }
                }
                else
                {
                    TestHelper.Monitor.Info( "CK.UK_CK_tActorPhoneNumber_PhoneNumber constraint NOT found: PhoneNumber can be shared among users." );
                    TestWithoutUnicityConstraint( phoneNumbers, ctx, uniquePhoneNumber, uId2 );
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

        static string UniquePhoneNumber()
        {
            string suffix = Guid.NewGuid()
                .ToByteArray()
                .Take( 2 )
                .Select( b => Convert.ToString( b, 8 ).PadLeft( 3, '0' ) )
                .Aggregate( ( s1, s2 ) => $"{s1}{s2}" );
            return $"33123{suffix}";
        }
    }
}
