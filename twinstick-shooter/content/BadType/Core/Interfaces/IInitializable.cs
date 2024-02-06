namespace BadType.Interfaces;

public interface IInitializable
{
    public IInitializable Init()
    {
        return this;
    }
}