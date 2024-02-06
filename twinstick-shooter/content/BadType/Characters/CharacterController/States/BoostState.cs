using System;
using System.Diagnostics.Tracing;
using BadType.StateMachine;
using Godot;


namespace BadType.Character.CharacterController;

[GlobalClass]
public partial class BoostState : CharacterState
{
    [Export] private CharacterState SlideState;
    [Export] private CharacterState DashState;
    
    [Export] private int BoostMultiplier = 2;
    private Vector2 _direction = Vector2.Zero;
    private Timer _timer;

    public override void Enter()
    {
        Character.UseCharge();
        BoostMultiplier = Controller.Boost.BoostMultiplier;
        _timer = new Timer();
        _timer.OneShot = true;
        AddChild(_timer);
        _timer.Timeout += OnBoostReleaseTimerTimeout;
        base.Enter();
        GD.Print("Enter");
    }

    public override IState UnhandledInput(InputEvent @event)
    {
        if (@event.IsActionReleased("ui_accept"))
            _timer.Start(0.2);
        if (@event.IsActionPressed("ui_accept"))
        {
            _timer.Stop();
            return DashState;
        }
        return this;
    }

    private void OnBoostReleaseTimerTimeout()
    {
        Controller.ChangeState(SlideState);
    }

    public override IState Process(double delta)
    {
        Controller.Boost.CurrentBoost = Controller.Boost.CurrentBoost - (Controller.Boost.BoostCost * (float)delta);
        return this;
    }

    public override IState PhysicsProcess(double delta)
    {
        _direction = GetDirection() != Vector2.Zero ? GetDirection() : _direction;
        Character.Velocity = Character.Velocity.MoveToward(
            (Character.Velocity + Character.Speed * _direction * BoostMultiplier).LimitLength(Character.Speed * BoostMultiplier), 
            Character.Speed * 4 * (float)delta);
        Character.MoveAndSlide();
        return this;
    }
}