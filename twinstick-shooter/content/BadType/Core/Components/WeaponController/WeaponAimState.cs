using BadType.StateMachine;
using Godot;


namespace BadType.Components.WeaponController;

[GlobalClass]
public partial class WeaponAimState : WeaponState
{
    public const string ATTACK_ACTION = "weapon_fire";
    
    [Export] public WeaponState IdleState;
    [Export] public WeaponState FireState;
    
    [Export] private bool _autoAim = false;
    [Export] private bool _autoFire = false;
    
    private Node2D _target;

    public override IState PhysicsProcess(double delta)
    {
        if (!Controller.ManualAim)
        {
            _target = GetTarget();
            if (_target == null) return GetStateFromNode(IdleState);

            if (!IsFixed)
                Weapon.Pivot.AimAt(_target.GlobalPosition); 
        }
        else
        {
            Vector2 mousePosition = Weapon.GetGlobalMousePosition();
            Weapon.Pivot.AimAt(mousePosition);
        }

        if (Controller.ManualAim && Weapon.CanAttack() && Input.IsActionPressed(ATTACK_ACTION))
        {
            return GetStateFromNode(FireState);
        }

        if (!Controller.ManualAim && Weapon.CanAttack())
            return FireState;
        return this;
    }
}