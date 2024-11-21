using CK.Core;

namespace CK.DB.Actor.ActorPhoneNumber;

/// <summary>
/// Brings <see cref="ActorPhoneNumberTable"/> to support phone numbers' user.
/// </summary>
[SqlPackage( Schema = "CK", ResourcePath = "Res" )]
[Versions( "1.0.0" )]
public class Package : SqlPackage
{
    void StObjConstruct( Actor.Package actorPackage )
    {
    }

    /// <summary>
    /// Gets the <see cref="ActorPhoneNumberTable"/>.
    /// </summary>
    public ActorPhoneNumberTable ActorPhoneNumberTable { get; protected set; }

}
