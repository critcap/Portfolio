using System;
using System.Linq;
using Badtype.Actors;
using BadType.Interfaces;
using BadType.Notifications;
using Godot;


namespace BadType.Weapons;


public partial class Weapon : Node2D, IWeapon
{
    [Signal] public delegate void WeaponAttackEventHandler();
    private double _attackCooldown = 0;

    [Export] public int Range { get; set; }
    [Export] public int Damage { get; set; }
    [Export] public float AttackRate { get; set; }
    [Export] public Area2D Area { get; set; }
    [Export] public bool IsFixated { get; set; } = false;
    public WeaponPivot Pivot;

    public override void _Ready()
    {
        if (!IsFixated)
            Pivot = GetNode<WeaponPivot>("Pivot");
                
        Area ??= GetNode<Area2D>("Area2D");
        CircleShape2D area = Area.GetNode<CollisionShape2D>("CollisionShape2D").Shape as CircleShape2D;
        area.Radius = Range;
    }

    /// <summary>
    /// Post PerformAttackNotification, emits WeaponAttack signal, and resets _attackCooldown
    /// </summary>
    public virtual void PerformAttack()
    {
        _attackCooldown = 0;
        this.PostNotification(PerformAttackNotification<Weapon>());
        EmitSignal(SignalName.WeaponAttack);
    }

    /// <summary>
    /// Returns true if _attackCooldown is greater than or equal to AttackRate
    /// </summary>
    /// <returns>If Weapon can attack</returns>
    public virtual bool CanAttack()
    {
        return _attackCooldown >= AttackRate;
    }

    /// <summary>
    /// Handles the cooldown for the weapon
    /// </summary>
    /// <param name="delta">Amount which _attackCooldown gets incremented</param>
    protected virtual void ProcessWeaponCooldown(double delta)
    {
        if (CanAttack()) return;
        _attackCooldown += delta;
    }

    public override void _PhysicsProcess(double delta)
    {
        ProcessWeaponCooldown(delta);
    }

    /// <summary>
    /// Returns PerformAttackNotification for the given weapon type
    /// </summary>
    /// <typeparam name="T">Weapon Type</typeparam>
    /// <returns>typeof(Weapon).PerformAttackNotification</returns>
    public static string PerformAttackNotification<T>()
    {
        return $"{typeof(T)}.PerformAttackNotification";
    }
}