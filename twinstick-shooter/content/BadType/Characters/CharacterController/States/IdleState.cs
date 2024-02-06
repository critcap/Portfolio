using BadType.StateMachine;
using Godot;


namespace BadType.Character.CharacterController;

[GlobalClass]
public partial class IdleState : CharacterState
{
    [Export] private CharacterState DashState;
    [Export] private CharacterState MoveState;
    [Export] private CharacterState WalkState;

    public override void Enter()
    {
        base.Enter();
        Character.Sprite.Play("Idle");
        if (Character is null) return;
        Character.Velocity = Vector2.Zero;
    }

    public override void Exit()
    {
        base.Exit();
        Character.Sprite.Play("default");
    }

    public override IState UnhandledInput(InputEvent @event)
    {
        if (@event is not InputEventKey && @event is not InputEventJoypadMotion)
            return null;
        if (HasDirection() && @event.IsActionPressed("ui_accept"))
            return DashState;
        if (GetDirection() != Vector2.Zero)
            return WalkState;
        return this;
    }
}