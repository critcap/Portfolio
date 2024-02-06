using Godot;

namespace BadType.Systems.VictoryConditions;

[GlobalClass]
public partial class VictoryCondition: Node
{
    [Signal] public delegate void GameoverEventHandler(bool isVictory);
}