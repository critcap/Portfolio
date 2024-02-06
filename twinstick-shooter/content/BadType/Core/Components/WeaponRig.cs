using System.Collections.Generic;
using BadType.Weapons;
using Godot;


namespace BadType.Components;

[GlobalClass]
public partial class WeaponRig : Node2D
{
    private readonly IList<Weapon> _weapons = new List<Weapon>();

    // TODO settings
    [Export] private int _maxWeapons = 12;
    [Export] public int Radius { get; set; } = 40;

    public override void _Ready()
    {
        if (GetChildren().Count == 0) return;
        foreach (var child in GetChildren())
        {
            if (child is not Weapon weapon) continue;
            AddWeapon(weapon);
        }
    }

    public void AddWeapon(Weapon weapon)
    {
        if (_weapons.Count >= _maxWeapons) return;
        _weapons.Add(weapon);
        if (weapon.GetParent() != this)
            AddChild((Node2D)weapon);
        RearrangeWeapons();
    }

    private void RearrangeWeapons()
    {
        if (_weapons.Count == 0) return;
        for (var i = 0; i < _weapons.Count; i++)
        {
            var weapon = (Node2D)_weapons[i];
            Vector2 position = GetWeaponPosition(i, _weapons.Count, Radius);
            weapon.Position = position;
        }
    }

    private static Vector2 GetWeaponPosition(int index, int max, int radius)
    {
        float angle = 2 * Mathf.Pi * index / max;
        angle += Mathf.Pi * (max == 4 ? 1.25f : 1f);
        return new Vector2(radius * Mathf.Cos(angle), radius * Mathf.Sin(angle));
    }

    public void SetWeaponsDirection(bool isRight)
    {
        foreach (Weapon child in GetChildren())
        {
            child.Pivot.Flip = isRight;
        }
    }
}