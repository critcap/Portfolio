using System.Reflection;
using BadType.Actions;
using BadType.Interfaces;
using BadType.Notifications;
using Godot;

namespace BadType.Systems;

public partial class DeathSystem: Node
{
    public override void _Ready()
    {
        this.AddObserver(OnDamageTaken, DamageSystem.DamageTakenNotification);
    }
    
    public override void _ExitTree()
    {
        this.RemoveObserver(OnDamageTaken, DamageSystem.DamageTakenNotification);
    }

    private void OnDamageTaken(object sender, object target)
    {
        var destructible = (IDestructible)target;
        Health health = destructible.Health;
        if (health.CurrentHealth > 0) return;
        GD.Print("Unit died!");
        var dead = (Node)destructible;
        this.PostNotification(DeathNotification(target));
        dead.QueueFree();
    }

    public static string DeathNotification<T>()
    {
        return $"{typeof(T)}.DeathNotification";
    }
    
    public static string DeathNotification(object target)
    {
        return $"{target.GetType()}.DeathNotification";
    }
}