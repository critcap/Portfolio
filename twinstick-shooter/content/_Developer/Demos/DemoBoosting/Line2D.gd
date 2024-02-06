extends Line2D

@export var character: CharacterBody2D
@export var length: int = 100

func _physics_process(delta):
	if !character:
		return
	var dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	clear_points()
	add_point(Vector2.ZERO)
	add_point(dir * length)
	
