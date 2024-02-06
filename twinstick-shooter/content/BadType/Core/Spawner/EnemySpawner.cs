using System;
using BadType.Actors;
using BadType.Interfaces;
using Godot;
using Godot.Collections;


namespace BadType.Spawner;

[GlobalClass]
public partial class EnemySpawner : Node2D, IInitializable
{
    private const string ENEMY_GROUP = "ActiveEnemies";
    [Export] public int spawnCount = 100;
    [Export] public float spawnDeadZone = 600f;
    private Node2D target;
    private int MaxIntensity = 20;
    private int intensity = 0;
    private ulong? timeStamp;

    public override void _Ready()
    {
        target = GetNode<PlayerCharacterBase>("%PlayerCharacterBase");
    }

    public override void _Process(double delta)
    {
        if (!CanSpawnEnemy()) return;
        Array<Node> enemies = GetTree().GetNodesInGroup(ENEMY_GROUP) ?? new Array<Node>();
        if (enemies.Count >= spawnCount)
        {
            // TODO Add routine for replacing old stuff
            return;
        }
        EnemyPawnBase enemy = GD.Load<PackedScene>("res://BadType/Enemies/EnemyPawnBase.tscn")
            .Instantiate<EnemyPawnBase>();
        enemy.Position = GetRandomSpawnPosition(target.GlobalPosition);
        enemy.Target = target;
        enemy.AddToGroup(ENEMY_GROUP);
        AddChild(enemy);
    }

    private bool CanSpawnEnemy()
    {
        if(Time.GetTicksMsec() - (timeStamp ??= Time.GetTicksMsec()) < 1000) return false;
        timeStamp = Time.GetTicksMsec();
        return true;
    }

    private Vector2 GetRandomSpawnPosition(Vector2 playerPosition)
    {
        var spawnPosition = new Vector2();
        var spawnDistance = 0f;
        var rnd = new Random();
        var Bounds = (Vector2I) (GetViewport().GetVisibleRect().Size / 2);
        while (spawnDistance < spawnDeadZone)
        {
            spawnPosition = new Vector2(
                rnd.Next(-Bounds.X, Bounds.X),
                rnd.Next(-Bounds.Y, Bounds.Y)
            );
            spawnPosition += playerPosition; 
            spawnDistance = spawnPosition.DistanceTo(playerPosition);
        }
        return spawnPosition;
    }
}