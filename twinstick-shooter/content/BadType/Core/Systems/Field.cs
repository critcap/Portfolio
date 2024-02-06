using Godot;
using System;
using System.Collections.Generic;
using BadType.Actors;
using BadType.Interfaces;

public partial class Field : Node, IInitializable
{
	public List<EnemyPawnBase> Enemies { get; } = new List<EnemyPawnBase>();
	public PlayerCharacterBase Player;

	public IInitializable Init()
	{
		throw new NotImplementedException();
	}
}
