using Godot;
using System;
using BadType.Components.WeaponController;
using BadType.StateMachine;
using BadType.Weapons;

public partial class WeaponAttackState : WeaponState
{
    [Export] public WeaponState IdleState;
    [Export] public WeaponState AimState;

    public override void Enter()
    {
        base.Enter();
        Weapon.PerformAttack();
    }

    public override IState PhysicsProcess(double delta)
    {
        if (Controller.ManualAim) return AimState;
        return GetTarget() == null ? IdleState : AimState;
    }
}