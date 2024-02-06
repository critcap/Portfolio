namespace BadType.Interfaces;

public interface IAction
{
    public const string ActionPerformedNotification = "ActionPerformedNotification";
    public void Execute();
}