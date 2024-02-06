using System.Numerics;
using BadType.Actions;
using Godot;
using BadType.Enums;
using BadType.Interfaces;
using BadType.Notifications;
using BadType.Systems;
using Vector2 = Godot.Vector2;

[GlobalClass]
public partial class EnemyPawnBase : CharacterBody2D, IDestructible, IInitializable
{
    private const int MaxSpeed = 250;
    [Export] public int Speed { get; set; }
    [Export] public AnimatedSprite2D Sprite { get; set; }
    [Export] public Factions Faction { get; set; }
    public Node2D Target { get; set; }

    public Health Health { get; set; }

    public override void _Ready()
    {
        Health = new Health(100);
        AddChild(Health);
        this.AddObserver(OnDamage, DamageSystem.DamageTakenNotification);
    }

    private void OnDamage(object arg1, object arg2)
    {
        if (arg2 == this)
        {
            GetNode<AnimationPlayer>("AnimationPlayer").Play("Flash");
        }
    }
    

    public IInitializable Init(Vector2 position)
    {
        MotionMode = MotionModeEnum.Floating;
        GlobalPosition = position;
        MaxSlides = 1;
        return this;
    }

    public override void _PhysicsProcess(double delta)
    {
        if (Speed < MaxSpeed)
        {
            Speed += 4;
        }
        
        if (Velocity.X != 0)
            Sprite.FlipH = Velocity.X <= 0;
    }
}