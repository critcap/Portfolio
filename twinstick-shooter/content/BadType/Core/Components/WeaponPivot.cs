using Godot;


namespace Badtype.Actors;

public partial class WeaponPivot: Node2D
{
    public bool Flip { get; set; } = false;
    public void AimAt(Vector2 target)
    {
        var sprite = GetNode<Sprite2D>("Sprite2D");
        var angle = (target - GlobalPosition).Angle();
        GlobalRotation = angle;
        sprite.FlipV = (Mathf.Abs(GlobalRotation)) > Mathf.Pi / 2;
    }

    public void ResetFlipV()
    {
        var sprite = GetNode<Sprite2D>("Sprite2D");
        sprite.FlipV = false;
    }

	public override void _UnhandledInput(InputEvent @event)
	{
		if (@event.IsActionPressed("ui_left"))
		{
			Flip = true;
		}
		else if (@event.IsActionPressed("ui_right"))
		{
			Flip = false;
		}
	}
}