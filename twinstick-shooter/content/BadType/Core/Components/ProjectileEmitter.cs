using BadType.Notifications;
using BadType.Weapons;
using Godot;


namespace Badtype.Components;

[GlobalClass]
public partial class ProjectileEmitter: Marker2D
{
    public const string ProjectileEmitNotification = "ProjectileEmitNotification";

    public void OnWeaponAttack()
    {
        this.PostNotification(ProjectileEmitNotification, (Weapon) Owner);
    }
}