using System;
using System.Collections.Generic;
using System.Linq;
using Badtype.Actors;
using Badtype.Components;
using BadType.Notifications;
using BadType.ViewModels;
using BadType.Weapons;
using Godot;
using Godot.Collections;

namespace BadType.Spawner;

public partial class ProjectileSpawner : Node
{
    [Export] public PackedScene ProjectileScene { get; set; } = null!;
    [Export] private int _maxProjectiles = 100;
    private Queue<Projectile> Projectiles = new Queue<Projectile>();

    public override void _Ready()
    {
        this.AddObserver(OnWeaponShootNotification, ProjectileEmitter.ProjectileEmitNotification);
    }

    public override void _ExitTree()
    {
        // this.RemoveObserver(OnWeaponShootNotification, Weapon.PerformAttackNotification<Weapon>());
    }

    private void OnWeaponShootNotification(object sender, object args)
    {
        var emitter = (ProjectileEmitter) sender;
        var weapon = (Weapon) args;
        var pivot = weapon.Pivot;
        if (GetChildren().Count < _maxProjectiles)
        {
            var projectile = ProjectileScene.Instantiate<Projectile>();
            projectile.GlobalTransform = emitter.GlobalTransform;
            AddChild(projectile);
            projectile.MaxRange = weapon.Range;
            Projectiles.Enqueue(projectile);
        }
        else
        {
            Projectile projectile = Projectiles.Dequeue();
            projectile.SetProcess(true);
            projectile.GlobalTransform = emitter.GlobalTransform;
            projectile.Visible = true;
            projectile.TopLevel = true;
            projectile.travelled = 0f;
            projectile.MaxRange = weapon.Range;
            Projectiles.Enqueue(projectile);
        }
    }

    // private Projectile RequestProjectile()
    // {
    //     Array<Node> children = GetChildren();
    //     if (children.Count < _maxProjectiles)
    //     {
    //         var projectile = 
    //         AddChild(projectile);
    //         return projectile;
    //     }
    //     
    //     children?.Where(x => !x.IsProcessing());
    //     GD.Print(children.Count.ToString());
    //     return children.FirstOrDefault() as Projectile;
    // }
}