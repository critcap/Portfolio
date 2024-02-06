using Godot;
using System;
using BadType.Actors;
using BadType.Spawner;
using BadType.StateMachine;

public partial class LevelController : StateMachine
{
	public EnemyPawnBase Enemy;
	public PlayerCharacterBase Player;

	private EnemySpawner EnemySpawner;
	[Export] public int EnemyCount = 10;
	
	// TODO
	// field
	// enemy vm
	// player vm
	
	
	public override void _Ready()
	{
		// var @object = Activator.CreateInstance(typeof(InitState));
	}
}
