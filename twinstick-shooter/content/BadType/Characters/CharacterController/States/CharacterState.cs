using BadType.Actors;
using BadType.StateMachine;
using Godot;

namespace BadType.Character.CharacterController;

public partial class CharacterState : NodeState
{
    protected PlayerCharacterBase Character => Controller.Character;
    protected CharacterController Controller;

    public override void _Ready()
    {
        Controller = Owner as CharacterController;
    }

    /// <summary>
    /// Returns the direction Vector of the movement input.
    /// </summary>
    /// <returns>Normalized input Vector2</returns>
    protected Vector2 GetDirection()
    {
        return Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
    }

    /// <summary>
    /// Checks whether the object has a non-zero direction.
    /// </summary>
    /// <returns>True if the object has a non-zero direction; otherwise, false.</returns>
    protected bool HasDirection()
    {
        return GetDirection() != Vector2.Zero;
    }

    /// <summary>
    /// Checks whether the input direction is opposite to the characters velocity.
    /// </summary>
    /// <returns>Returns true if the input direction is opposite to the characters velocity; otherwise, false</returns>
    protected bool IsOppositeDirection()
    {
        return GetDirection().Dot(Character.Velocity) < 0.0;
    }
    
    protected Vector2 GetCardinalDirection(Vector2 direction)
    {
        if (direction == Vector2.Zero) return Vector2.Zero;
        if (Mathf.Abs(direction.X) > Mathf.Abs(direction.Y))
            return new Vector2(Mathf.Sign(direction.X), 0);
        return new Vector2(0, Mathf.Sign(direction.Y));
    }
}