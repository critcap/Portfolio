using BadType.Actors;
using Godot;

namespace BadType.Character.CharacterController;

[GlobalClass]
public partial class CharacterController : StateMachine.StateMachine
{
    [Export] public PlayerCharacterBase Character;
    [Export] public Camera2D Camera;
    [Export] public Node2D WeaponPivot;
    [Export] public Boost Boost;
    
    [Export] public int Speed = 200;
    [Export] public int MaxSpeed;
    
    [Export] public float DashMultiplier = 2f;
    [Export] public double DashDuration = 0.2;
    
    [Export] public int SlideDrag = 200;
    [Export] public float SlideSteeringForce = 1.5f;
    [Export] public float SlideBreakForce = 2f;
}