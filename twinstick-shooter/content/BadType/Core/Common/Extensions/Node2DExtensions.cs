using Godot;

namespace BadType.Extensions;

public static class Node2DExtensions
{
    public static void FlipNode2D(this Node2D node, bool flip)
    {
        var flipX = flip ? -1 : 1;
        if (node.Scale.X == flipX)
            return;
        node.Scale = new Vector2(flipX, 1);
        //node.Rotation = node.Rotation * (flip ? -1 : 1);
    }
}