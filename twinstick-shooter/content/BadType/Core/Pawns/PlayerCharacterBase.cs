using System.Numerics;
using BadType.Components;
using BadType.Enums;
using BadType.Extensions;
using BadType.Interfaces;
using BadType.Weapons;
using Godot;
using Godot.Collections;
using Vector2 = Godot.Vector2;

namespace BadType.Actors;

public partial class PlayerCharacterBase : CharacterBody2D, IDestructible, IInitializable
{
    public Factions Faction { get; }
    [Export] public Health Health { get; set; }
    public AnimatedSprite2D Sprite => GetNode<AnimatedSprite2D>("AnimatedSprite2D");
    public WeaponRig WeaponRig => GetNode<WeaponRig>("WeaponRig");
    [Export] public int Speed { get; set; }

    [Export] public double Charge { get; private set; }
    [Export] private double ChargeRate { get; set; }
    [Export] private double ChargeMax { get; set; } = 2d;
    public bool CanBoost => Charge >= 1d;
    private float _lastDirection = 1f;
    
    public void UseCharge()
    {
        if (Charge < 1d) return;
        Charge -= 1.5d;
    }
    
    /// <summary>
    /// Returns true if the player is sliding.
    /// </summary>
    public bool IsSliding => Velocity.Length() > Speed;
    
    public void OnDirectionChanged(bool isRight)
    {
        Sprite.FlipH = isRight;
    }

    public override void _Ready()
    {
        Health = new Health(100);
        AddChild(Health, true);
    }

    public PlayerCharacterBase Init(Health health)
    {
        Health = new Health(100);
        AddChild(health, true);
        return this;
    }

    public override void _PhysicsProcess(double delta)
    {
       if (Charge < ChargeMax) Charge = Mathf.Min(Charge + delta , ChargeMax);
       
       if (Velocity.X != 0)
            Sprite.FlipH = Velocity.X <= 0;
    }   
}