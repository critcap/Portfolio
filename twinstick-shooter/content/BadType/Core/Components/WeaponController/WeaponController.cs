using Godot;
using System;
using BadType.StateMachine;
using BadType.Weapons;

namespace BadType.Components.WeaponController;
[GlobalClass]
public partial class WeaponController : StateMachine.StateMachine
{
    [Export] public Weapon Weapon;
    [Export] public bool ManualAim;
}
