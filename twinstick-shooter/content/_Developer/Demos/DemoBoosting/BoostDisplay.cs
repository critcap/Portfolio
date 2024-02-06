using Godot;
using System;

public partial class BoostDisplay : HBoxContainer
{
    [Export] private Booster Booster;
    private Label CurrentBoost;
    private Label MaxBoost;

    public override void _Ready()
    {
        CurrentBoost = GetNode<Label>("BoostCurrent");
        MaxBoost = GetNode<Label>("BoostMax");
        
        if (Booster is null) return;

        MaxBoost.Text = $"|{Booster.Max}";
    }

    public override void _Process(double delta)
    {
        if (Booster is null) return;

        CurrentBoost.Text = $"{Booster.Current}";
    }
}
