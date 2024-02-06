using System;
using System.Diagnostics;
using BadType.StateMachine;
using Godot;


namespace BadType.Character.CharacterController;

[GlobalClass]
public partial class DashState : MoveState
{
    [Export] private CharacterState SlideState;
    [Export] private CharacterState IdleState;
    [Export] private CharacterState MoveState;
	[Export] private CharacterState WalkState;

    private double _progress = 0;
    private Vector2 _dashVelocity = Vector2.Zero;
    private Vector2 _previousVelocity = Vector2.Zero;

    public override void Enter()
    {
        Init();
        Character.UseCharge();
        Character.Sprite.Play("Dash");
        Vector2 direction = GetDirection();
        _previousVelocity = Character.Velocity.Length() * GetDirection() * 0.5f;
        if (direction == Vector2.Zero) return;
        _dashVelocity = direction  * Controller.Speed * Controller.DashMultiplier;
        Controller.Camera.PositionSmoothingSpeed = 0.01f;
    }

    public override void Exit()
    {
        Character.Sprite.Play("default");
        Controller.Camera.PositionSmoothingSpeed = 5f;
    }

    private void Init()
    {
        _progress = 0d;
        _previousVelocity = Vector2.Zero;
        _dashVelocity = Vector2.Zero;
    }

    public override IState PhysicsProcess(double delta)
    {
        if (Mathf.IsEqualApprox(_progress, Controller.DashDuration, 0.01))
        {
            if (InputBuffer.IsActionHold("ui_accept"))
            {
                Character.Velocity = Character.Velocity.LimitLength(Character.Speed * 2);
                return SlideState;
            }
            if (GetDirection() != Vector2.Zero)
                return WalkState;
            return IdleState;
        }
        if (Mathf.IsEqualApprox(_progress, Controller.DashDuration * 0.6f, 0.01))
        {
            Controller.Camera.PositionSmoothingSpeed = 8f;
        }
        
        _progress += delta;
        Vector2 velocity = _dashVelocity / (float) Controller.DashDuration;
        velocity += _previousVelocity;
        Character.Velocity = velocity.LimitLength(Controller.MaxSpeed);
        Character.MoveAndSlide();
        return this;
    }
}