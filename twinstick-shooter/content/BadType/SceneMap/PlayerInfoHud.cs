using BadType.Actors;
using BadType.Interfaces;
using BadType.Notifications;
using Godot;

public partial class PlayerInfoHud : Control, IInitializable
{
    private Label _labelHealthCurrent;
    private Label _labelHealthMax;
    private Label _labelKills;
    private ProgressBar _progressBarHealth;

    public override void _Ready()
    {
        _labelHealthCurrent = GetNode<Label>("%LabelHealthCurrent");
        _labelHealthMax = GetNode<Label>("%LabelHealthMax");
        _progressBarHealth = GetNode<ProgressBar>("%ProgressBarHealth");
        _labelKills = GetNode<Label>("%LabelKills");
    }

    public PlayerInfoHud Init(PlayerCharacterBase player)
    {
        Health health = player.Health;
        health.HealthChanged += OnHealthChanged;
        UpdateHealth(health.CurrentHealth, health.MaxHealth);
        UpdateKillCount(0);

        return this;
    }

    private void UpdateHealth(int currentHealth, int maxHealth)
    {
        _progressBarHealth.MaxValue = maxHealth;
        _progressBarHealth.Value = currentHealth;
        _labelHealthCurrent.Text = currentHealth.ToString();
        _labelHealthMax.Text = maxHealth.ToString();
    }

    private void UpdateKillCount(int killCount)
    {
        _labelKills.Text = killCount.ToString();
    }

    private void OnHealthChanged(int current, int max)
    {
        UpdateHealth(current, max);
    }

    private void OnPlayerKill(object arg1, object arg2)
    {
        UpdateKillCount((int) arg2);
    }
}