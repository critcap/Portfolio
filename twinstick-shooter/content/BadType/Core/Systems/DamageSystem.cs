using BadType.Actions;
using BadType.Interfaces;
using BadType.Notifications;
using BadType.ViewModels;
using Godot;

namespace BadType.Systems;

public partial class DamageSystem : Node
{
    public const string DamageTakenNotification = "DamageTakenNotification";

    public override void _Ready()
    {
        this.AddObserver(OnDamageAction, Global.PerformNotification<DamageAction>());
    }

    public override void _ExitTree()
    {
        this.RemoveObserver(OnDamageAction, Global.PerformNotification<DamageAction>());
    }

    private void OnDamageAction(object sender, object args)
    {
        var damageAction = (DamageAction) sender;
        ApplyDamage(damageAction.Target, damageAction.Damage);
    }

    private void ApplyDamage(IDestructible target, int damage)
    {
        Health health = target.Health;
        health.CurrentHealth -= damage;
        if (damage <= 0) return;

        this.PostNotification(DamageTakenNotification, target);
    }
}