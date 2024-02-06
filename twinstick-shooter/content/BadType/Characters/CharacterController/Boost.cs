using Godot;
using System;
using BadType.Interfaces;

public partial class Boost : Node, IInitializable
{
    [Export] public int MaxBoost { get; set; }
    public double CurrentBoost
    {
        get => _currentBoost;
        set => _currentBoost = Mathf.Min(value, MaxBoost);
    }
    [Export] public int BoostRegen { get; set; }
    [Export] public int BoostCost { get; set; }
    [Export] public int BoostMultiplier { get; set; }
    [Export] public bool IsRegenerating { get; set; }
    
    private double _currentBoost;

    public override void _Process(double delta)
    {
        if (!IsRegenerating) return;
        ApplyRegen(delta);
    }
    
    public bool CanBoost()
    {
        return CurrentBoost >= BoostCost;
    }
    
    private void ApplyRegen(double delta)
    {
        if (_currentBoost == MaxBoost) return;
        _currentBoost = Mathf.Min(_currentBoost + BoostRegen * delta, MaxBoost);
    }
}
