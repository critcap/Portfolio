using System.Collections.Generic;
using System.Linq;
using BadType.StateMachine;
using BadType.Weapons;
using Godot;
using Godot.Collections;

namespace BadType.Components.WeaponController;

public partial class WeaponState : NodeState
{
    protected WeaponController Controller;
    protected Weapon Weapon => Controller.Weapon;
    public bool IsFixed => Weapon?.Pivot is null;

    public override void _Ready()
    {
        Controller = Owner as WeaponController;
    }

    protected Node2D GetTarget()
    {
        Array<Node2D> bodies = Weapon.Area.GetOverlappingBodies();
        if (bodies is null || bodies.Count == 0) return null;
        IEnumerable<Node2D> enemies = bodies.Where(body => body is EnemyPawnBase);
        if (enemies is null || !enemies.Any()) return null;
        return enemies.MinBy(body => Weapon.GlobalPosition.DistanceTo(body.GlobalPosition));
    }
}