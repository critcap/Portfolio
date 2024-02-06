using BadType.Enums;
using BadType.Interfaces;
using Godot;

namespace BadType.Components;

public partial class Faction: Node, IInitializable
{
    public Factions Type { get; set; }
    
    public bool IsFriendly(Node actor)
    {
        var actorFaction = actor.GetNode<Faction>("Faction");
        if (IsNeutral(actor)) return false;
        return Type == actorFaction.Type;
    }
    
    public bool IsNeutral(Node actor)
    {
        var actorFaction = actor.GetNode<Faction>("Faction");
        if (actorFaction == null) return true;
        return actorFaction.Type == Factions.Neutral;
    }
    
    public IInitializable Init(Factions type)
    {
        Type = type;
        return this;
    }
    
    public IInitializable Init(int type)
    {
        Type = (Factions) type;
        return this;
    }
}