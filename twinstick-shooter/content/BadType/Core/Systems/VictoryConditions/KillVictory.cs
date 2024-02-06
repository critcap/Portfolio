using BadType.Notifications;
using Godot;

namespace BadType.Systems.VictoryConditions;

public partial class KillVictory: VictoryCondition
{
    [Export] public int Threshold;
    public int Progress { get; set; }

    public override void _Ready()
    {
        this.AddObserver(OnEnemyDeath, DeathSystem.DeathNotification<EnemyPawnBase>());
    }

    private void OnEnemyDeath(object arg1, object arg2)
    {
        Progress++;
        if (!IsVictory()) return;
        EmitSignal(SignalName.Gameover, true);
    }
    
    private bool IsVictory()
    {
        return Progress >= Threshold;
    }
}