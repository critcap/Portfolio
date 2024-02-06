using System.Collections.Generic;
using Godot;

namespace BadType.Systems;

public partial class NavigationQueue: Node
{
    private Queue<NavigationAgent2D> _queue;

    public override void _Ready()
    {
        _queue = new Queue<NavigationAgent2D>();
    }

    public override void _ExitTree()
    {
        
    }
}