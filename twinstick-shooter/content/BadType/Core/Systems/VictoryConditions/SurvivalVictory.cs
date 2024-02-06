using BadType.Actors;
using BadType.Notifications;
using Godot;

namespace BadType.Systems.VictoryConditions;

public partial class SurvivalVictory: VictoryCondition
{
    public override void _Ready()
    {
        this.AddObserver(OnPlayerDeath, DeathSystem.DeathNotification<PlayerCharacterBase>());
    }

    private void OnPlayerDeath(object sender, object args)
    {
        EmitSignal(SignalName.Gameover, false);
    }
}