using BadType.Interfaces;
using BadType.Notifications;

namespace BadType.Actions;

public class DamageAction : IAction
{
    public int Damage;
    public IDestructible Target;

    public DamageAction(IDestructible target, int damage)
    {
        Target = target;
        Damage = damage;
    }

    public void Execute()
    {
        var notification = Global.PerformNotification<DamageAction>();
        this.PostNotification(notification);
    }
}