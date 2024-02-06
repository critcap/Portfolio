using BadType.Actors;
using BadType.Interfaces;
using BadType.Notifications;
using BadType.Weapons;
using Godot;


namespace BadType.Components.WeaponController;

[GlobalClass]
public partial class HitboxWeapon : Weapon
{
    public override void _Ready()
    {
        base._Ready();
        Area.BodyEntered += OnBodyEntered;
    }

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        if (!CanAttack()) return;
        if (Area.GetOverlappingBodies().Count == 0) return;
        var target = Area.GetOverlappingBodies()[0] as IDestructible;
        HitTarget(target);
    }

    private void OnBodyEntered(Node body)
    {
        if (!CanAttack()) return;
        if (body is not IDestructible destructible) return;
        HitTarget(destructible);
    }

    private void HitTarget(IDestructible target)
    {
        PerformAttack();
        this.PostNotification(EnemyHitNotificiation<PlayerCharacterBase>(), target);
    }

    public static string EnemyHitNotificiation<T>()
    {
        return $"{typeof(T)}.EnemyHitNotificiation";
    }
}