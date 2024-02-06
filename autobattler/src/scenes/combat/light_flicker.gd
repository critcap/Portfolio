extends OmniLight


export var min_reduction: float = 0.1
export var max_increase: float = 0.2
export var speed: float = 1.0
export var active: bool = false 
export var light_mult: float = 7.5
var rng = RandomNumberGenerator.new()
var base_energy: float = 1.11
var deltadelta = 0.16

func _process(delta) -> void:
	if active:
		flicker(delta)

func flicker(delta):
	while(active):
		if !active:
			break
		var difference = rng.randf_range(base_energy - min_reduction, base_energy + max_increase)
		omni_attenuation = lerp(omni_attenuation, difference, 1 * delta)
		yield(get_tree().create_timer(speed), "timeout")

