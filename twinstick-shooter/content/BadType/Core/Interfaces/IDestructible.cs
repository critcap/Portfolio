namespace BadType.Interfaces;

public interface IDestructible :  IInitializable
{
    Health Health { get; }

    bool IsAlive()
    {
        return Health.CurrentHealth > 0;
    }
}