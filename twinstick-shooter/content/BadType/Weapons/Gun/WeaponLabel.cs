using Godot;
using System;
using BadType.Weapons;

public partial class WeaponLabel : Label
{
    public override void _PhysicsProcess(double delta)
    {
        Text = Owner is Weapon weapon ? weapon.Pivot.GlobalRotation.ToString() : "Not a weapon";
    }
}
