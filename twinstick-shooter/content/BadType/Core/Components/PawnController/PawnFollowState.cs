using Godot;
using System;
using BadType.Actors;
using BadType.StateMachine;

using Vector2 = Godot.Vector2;

[GlobalClass]
public partial class PawnFollowState : PawnState
{
    [Export] private NavigationAgent2D NavigationAgent;
    [Export] private bool UsePathfinding;

    private Vector2 _currentWaypoint;

    public override IState PhysicsProcess(double delta)
    {
        if (Pawn.Target is null) return this;
        Vector2 direction;
        if (true)
        {
            direction = (Pawn.Target.GlobalPosition - Pawn.GlobalPosition).Normalized();
        }
        // else
        // {
        //     NavigationAgent.TargetPosition = Pawn.Target.GlobalPosition;
        //     _currentWaypoint = NavigationAgent.GetNextPathPosition();
        //     direction = (_currentWaypoint - Pawn.GlobalPosition).Normalized();
        // }

        Pawn.Velocity = direction * Pawn.Speed;
        Pawn.MoveAndSlide();
        
        var collider = Pawn.GetLastSlideCollision();
        if (collider != null && !(collider.GetCollider() is StaticBody2D))
        {
            Pawn.Speed = Mathf.Max(100, Pawn.Speed - 20);
        }

        return this;
    }

    public void OnNavigationAgentPathChanged()
    {
        _currentWaypoint = NavigationAgent.GetNextPathPosition();
    }
}