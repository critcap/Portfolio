using BadType.Notifications;
using BadType.Systems.VictoryConditions;
using Godot;


namespace BadType.Systems;

[GlobalClass]
public partial class VictorySystem: Node
{
    // TODO add to global
    public const string VictoryNotification = "VictorySystem.VictoryNotification";
    public const string DefeatNotification = "VictorySystem.DefeatNotification";

    public override void _Ready()
    {
        foreach (Node child in GetChildren())
        {
            if (child is not VictoryCondition condition) return;
            condition.Owner = this;
            condition.Gameover += OnGameover;
        }
    }

    private void OnGameover(bool isVictory)
    {
        if (isVictory)
        {
            this.PostNotification(VictoryNotification);
        }
        else
        {
            this.PostNotification(DefeatNotification);
        }
    }
    
}