class_name DamagePopup
extends Position2D

var anim_length: float = 0.6
var anim_jump_height: int = 150
var anim_destination: Vector2 = Vector2(200,0)

func perform_popup(amount: int, special: String ="") -> void:
	var tween = $Tween
	var label = $Label
	var origin = position
	var end = origin + anim_destination
	var height = origin.y - anim_jump_height
	z_index = 99

	label.text = str(str(amount) + special)
	tween.interpolate_property(self, "position:x", origin.x, end.x, anim_length, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "position:y", origin.y, height, anim_length/2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(self, "position:y", height, origin.y, anim_length/2, Tween.TRANS_QUAD, Tween.EASE_IN, anim_length/2)
	tween.interpolate_property(self, "scale", Vector2.ZERO, Vector2(6,6), anim_length, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, anim_length * 0.3, Tween.TRANS_QUAD, Tween.EASE_IN, anim_length * 0.7)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()
