using Godot;
using System;
using System.Diagnostics.Tracing;

public partial class Booster : Node2D
{
    [Export] public double Max = 1.0;
    [Export] public double Current = .0;
    [Export] public double BoostRate = 0.1;
    [Export] public double DecaySpeed;
    public override void _Ready()
    {
        Owner = GetParent();
    }
}
