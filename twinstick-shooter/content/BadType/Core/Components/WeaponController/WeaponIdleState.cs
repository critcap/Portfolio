using Badtype.Actors;
using BadType.Actors;
using BadType.Extensions;
using BadType.StateMachine;
using Godot;


namespace BadType.Components.WeaponController;

[GlobalClass]
public partial class WeaponIdleState : WeaponState
{
    [Export] public WeaponState AimState;

    public override void Enter()
    {
        if (IsFixed) return;
        Weapon.Pivot.ResetFlipV();
        Weapon.Pivot.GlobalRotationDegrees = 0;
    }

    public override void Exit()
    {
        if (IsFixed) return;
        Weapon.Pivot.Scale = new Vector2(1, 1);
    }

    public override IState PhysicsProcess(double delta)
    {
        if (Controller.ManualAim) return AimState;
        if (!IsFixed)
        {
            Weapon.Pivot.FlipNode2D(!Weapon.Pivot.Flip);
        }
        return GetTarget() == null ? this : GetStateFromNode(AimState);
    }
}