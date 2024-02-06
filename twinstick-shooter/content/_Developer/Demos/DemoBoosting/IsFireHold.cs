using Godot;
using System;

public partial class IsFireHold : Label
{
	private const string FireHold = "FireHold";
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		Text = $"{FireHold}: {InputBuffer.IsActionHold("weapon_fire")}";
	}
}
