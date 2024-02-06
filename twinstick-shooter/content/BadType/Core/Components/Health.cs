using System;
using Godot;

[GlobalClass]
public partial class Health : Node
{
    [Signal]
    public delegate void HealthChangedEventHandler(int currentHealth, int maxHealth);

    private int _currentHealth;

    [Export] private int _max;

    public Health(int maxHealth)
    {
        MaxHealth = maxHealth;
        CurrentHealth = maxHealth;
    }

    public int MaxHealth
    {
        get => _max;
        set
        {
            if (value == MaxHealth) return;
            _max = value;
            CurrentHealth = Mathf.Min(_max, CurrentHealth);
        }
    }

    public int CurrentHealth
    {
        get => _currentHealth;
        set
        {
            if (value == CurrentHealth) return;
            _currentHealth = value;
            EmitSignal(SignalName.HealthChanged, _currentHealth, MaxHealth);
        }
    }
}