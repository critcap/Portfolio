using System;
using BadType.StateMachine;
using Godot;


namespace BadType.Character.CharacterController;

[GlobalClass]
public partial class MoveState : CharacterState
{
    [Export] CharacterState DashState;
    [Export] CharacterState IdleState;
    
    public override IState UnhandledInput(InputEvent @event)
    {
        if (@event.IsActionPressed("ui_accept"))
            return DashState;
        return this;
    }

    public override IState PhysicsProcess(double delta)
    {
        Vector2 velocity = Character.Velocity;
        Vector2 direction = GetDirection();

        if (direction == Vector2.Zero) return IdleState;
        velocity = velocity.MoveToward(Character.Speed * direction, Character.Speed);
        Character.Velocity = velocity;
        Character.MoveAndSlide();
        return this;
    }
}