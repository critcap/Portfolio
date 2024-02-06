using BadType.Interfaces;
using Godot;

namespace BadType.StateMachine;

public interface IState: IInitializable
{
    /// <summary>
    /// Gets called when the state is entered
    /// </summary>
    public void Enter();

    /// <summary>
    /// Gets called when the state is exited
    /// </summary>
    public void Exit();

    /// <summary>
    /// Process function which gets called in _PhysicsProcess of its parent StateMachine
    /// </summary>
    /// <param name="delta">Propagated frame delta</param>
    public IState PhysicsProcess(double delta);

    /// <summary>
    /// Input function which gets called in _UnhandledInput of its parent StateMachine
    /// </summary>
    /// <param name="event">Propagated InputEvent</param>
    public IState UnhandledInput(InputEvent @event);
    
    public IState Process(double delta);
}