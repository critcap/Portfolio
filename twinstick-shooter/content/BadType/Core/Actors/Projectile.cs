using BadType.Notifications;
using Godot;

namespace BadType.ViewModels;

public partial class Projectile : Area2D
{
    public const string ProjectileHitNotification = "ProjectileHitNotification";

    [Export] public int MaxRange = 1200;
    [Export] public int Speed = 2000;
    public float travelled = 0f;

    public override void _Ready()
    {
        BodyEntered += OnBodyEntered;
    }

    private void OnBodyEntered(Node2D body)
    {
        this.PostNotification(ProjectileHitNotification, body);
        Disable();
    }

    public override void _PhysicsProcess(double delta)
    {
        var distance = Speed * delta;
        var motion = Transform.X * Speed * (float)delta;

        Position += motion;

        travelled += (float)distance;
        if (travelled < MaxRange) return;
        Disable();
    }

    private void Disable()
    {
        Visible = false;
        SetProcess(false);
    }
    private void Enable()
    {
        Visible = true;
        SetProcess(true);
    }
}