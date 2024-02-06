using System;
using System.Diagnostics;
using BadType.StateMachine;
using Godot;


namespace BadType.Character.CharacterController;

[GlobalClass]
public partial class SlideState : CharacterState
{
    [Export] private CharacterState DashState;
    [Export] private CharacterState IdleState;
    [Export] private CharacterState MoveState;

    public override IState UnhandledInput(InputEvent @event)
    {
        if (@event is not InputEventKey key || !key.IsActionPressed("ui_accept")) return this;
        return DashState;
    }

    public override IState PhysicsProcess(double delta)
    {
        if (Character.Velocity.IsZeroApprox()) return GetStateFromNode(IdleState);
        if (!Character.IsSliding && GetDirection() != Vector2.Zero)
        {
            if (!IsOppositeDirection())
                return GetStateFromNode(MoveState);
        }

        if (!IsOppositeDirection())
        {
            Vector2 direction = GetDirection();
            float angle = Character.Velocity.Normalized().AngleTo(direction);
            angle *= (float) delta * Controller.SlideSteeringForce;
            GD.Print(angle.ToString());
            Character.Velocity = Character.Velocity.Rotated(angle);
        }
        float DragMod = IsOppositeDirection() ? Controller.SlideBreakForce : 1f;
        Character.Velocity += Character.Velocity.Normalized() * -Controller.SlideDrag * DragMod * (float)delta;
        Character.Velocity = Character.Velocity.MoveToward(Vector2.Zero, Controller.Speed * 0.5f * (float) delta);
        Character.MoveAndSlide();
        return this;
    }
}