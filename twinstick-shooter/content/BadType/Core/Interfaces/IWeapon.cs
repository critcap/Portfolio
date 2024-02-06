namespace BadType.Interfaces;

public interface IWeapon
{
    int Range { get; }
    int Damage { get; }
    float AttackRate { get; }

    public void PerformAttack();
    public bool CanAttack();

    /// <summary>
    /// Returns PerformAttackNotification for the given weapon type
    /// </summary>
    /// <typeparam name="T">Weapon Type</typeparam>
    /// <returns>typeof(Weapon).PerformAttackNotification</returns>
    public string PerformAttackNotification<T>()
    {
        return $"{typeof(T)}.PerformAttackNotification";
    }
}