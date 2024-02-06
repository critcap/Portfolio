using System;
using BadType.Interfaces;
using Godot;

namespace BadType.StateMachine;

public partial class StateMachine : Node, IInitializable
{
    [Signal]
    public delegate void StateChangedEventHandler(Node state);

    private IState CurrentState { get; set; }

    public void ChangeState(IState state)
    {
        if (state is null)
            throw new ArgumentNullException(nameof(state));
        if (CurrentState == state)
            return;

        CurrentState?.Exit();
        CurrentState = state;
        CurrentState.Enter();
        EmitSignal(SignalName.StateChanged, CurrentState as Node);
    }

    public StateMachine Init(IState initialState)
    {
        ChangeState(initialState);
        return this;
    }

    public override void _Ready()
    {
        if (GetChildren().Count == 0) return;
        var initialState = GetChild(0) as IState;
        Init(initialState);
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        ChangeState(CurrentState?.UnhandledInput(@event) ?? CurrentState);
    }

    public override void _PhysicsProcess(double delta)
    {
        ChangeState(CurrentState?.PhysicsProcess(delta) ?? CurrentState);
    }
    
    public override void _Process(double delta)
    {
        ChangeState(CurrentState?.Process(delta) ?? CurrentState);
    }
}