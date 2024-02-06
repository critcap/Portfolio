using Godot;
using System;

[GlobalClass]
public partial class Camera : Node2D
{
	[Export] private Node2D Origin;
	[Export] private int MaxDistance = 800;
	[Export] private float DynamicOffset = 0.3f;

	[Export] private int maxHorizontalTrauma = 100;
	[Export] private int maxVerticalTrauma = 100;
	[Export] private FastNoiseLite noise;
	[Export] private double noiseSpeed = 50.0f;
	[Export] private double traumaDecay = 1.0f;

	private double _trauma;
	private double _time;

	private Camera2D _camera;

	public override void _Ready()
	{
		_camera = GetNode<Camera2D>("Camera2D");
	}

	public override void _Process(double delta)
	{
		Vector2 origin = Origin.GlobalPosition;
		Vector2 target = GetGlobalMousePosition() - origin;
		if (target.Length() > MaxDistance)
		{
			target = target.Normalized() * MaxDistance;
		}
		GlobalPosition = origin.Lerp(target + origin, 0.3f);

		_time += delta;
		_trauma = Mathf.Max(0f, _trauma - delta * traumaDecay);
		if (_trauma <= 0f) return;
		var offset = new Vector2();
		offset.X = (float)(maxHorizontalTrauma * GetShakeIntensity() * GetNoiseFromSeed(1));
		offset.Y = (float)(maxVerticalTrauma * GetShakeIntensity() * GetNoiseFromSeed(2));
		_camera.Offset = offset;
	}

	public void AddTrauma(double traumaValue)
	{
		_trauma = Mathf.Clamp(_trauma + traumaValue, 0d, 1d);
	}

	private double GetNoiseFromSeed(int seed)
	{
		noise.Seed = seed;
		return noise.GetNoise1D((float)(_time * noiseSpeed));
	}

	private double GetShakeIntensity()
	{
		return _trauma * _trauma;
	}
}
