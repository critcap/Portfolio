using Godot;
using System;
using BadType.Actors;

public partial class DemoBoosting : Node2D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GetNode<PlayerCharacterBase>("PlayerCharacterBase");
	}


}
