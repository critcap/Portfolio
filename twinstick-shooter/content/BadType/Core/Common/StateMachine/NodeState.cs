using Godot;

namespace BadType.StateMachine;

public partial class NodeState : Node, IState
{
    public virtual void Enter()
    {
    }

    public virtual void Exit()
    {
    }

    public virtual IState PhysicsProcess(double delta)
    {
        return this;
    }
    
    public virtual IState Process(double delta)
    {
        return this;
    }

    public virtual IState UnhandledInput(InputEvent @event)
    {
        return null;
    }

    /// <summary>
    /// Safely returns a StateNode from a Node if the Node is a CharacterBaseState
    /// </summary>
    /// <param name="node">Node to be verified</param>
    /// <returns>Verified CharacterBaseState</returns>
    /// <exception cref="ArgumentException"></exception>
    protected NodeState GetStateFromNode(Node node)
    {
        return node as NodeState ?? throw new System.ArgumentException($"Node is not a State", nameof(node));
    }
}