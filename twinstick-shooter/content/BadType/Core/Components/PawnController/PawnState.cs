using BadType.StateMachine;

namespace BadType.Actors;

public partial class PawnState: NodeState
{
    public EnemyPawnBase Pawn => Owner as EnemyPawnBase;
}