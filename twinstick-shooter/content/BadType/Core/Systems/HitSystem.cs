using BadType.Actions;
using BadType.Actors;
using BadType.Components.WeaponController;
using BadType.Interfaces;
using BadType.Notifications;
using BadType.ViewModels;
using Godot;

namespace BadType.Systems;

public partial class HitSystem : Node
{
    public const string PlayerDodgedNotification = "PlayerDodgedNotification";
    [Export] private float PlayerDodgeChance = 0.2f;

    public override void _Ready()
    {
        this.AddObserver(OnTargetHitNotification, Projectile.ProjectileHitNotification);
        this.AddObserver(OnTargetHitNotification, HitboxWeapon.EnemyHitNotificiation<PlayerCharacterBase>());
    }

    public override void _ExitTree()
    {
        this.RemoveObserver(OnTargetHitNotification, Projectile.ProjectileHitNotification);
    }

    private void OnTargetHitNotification(object sender, object body)
    {
        var target = (IDestructible) body;
        if (!target.IsAlive()) return;
        if (IsPlayerHit(target) && GD.Randf() < PlayerDodgeChance)
        {
            this.PostNotification(PlayerDodgedNotification, 10);
            return;
        }

        SendDamageAction(target, 10);
    }

    private void SendDamageAction(IDestructible target, int damage)
    {
        var damageAction = new DamageAction(target, damage);
        damageAction.Execute();
    }

    private bool IsPlayerHit(IDestructible target)
    {
        return target is PlayerCharacterBase;
    }
}