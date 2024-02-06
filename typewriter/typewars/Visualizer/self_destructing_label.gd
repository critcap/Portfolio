class_name SelfDestructingLabel
extends Label

var _is_destructing: bool = false setget , is_destructing


func is_destructing() -> bool:
	return _is_destructing


func self_destroy(timer: float) -> void:
	if _is_destructing:
		return
	_is_destructing = true
	animate_destruction(timer)


func commit_sudoku(timer: float) -> void:
	self_destroy(timer)


func animate_destruction(timer: float) -> void:
	var tween = Tween.new()
	add_child(tween)
	timer = timer / 2
	yield(get_tree().create_timer(timer), "timeout")
	tween.interpolate_property(
		self,
		"modulate",
		Color(1, 1, 1, 1.0),
		Color(1, 1, 1, 0.0),
		timer,
		tween.TRANS_LINEAR,
		tween.EASE_OUT
	)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
