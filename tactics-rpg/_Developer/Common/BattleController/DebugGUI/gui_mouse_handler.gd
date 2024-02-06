extends Node

var screen_pos
var world_pos


func _gui(_delta) -> void:
	screen_pos = GUI.label(str("Mouse Screen Pos: ", get_viewport().get_mouse_position()))
	GUI.label(str("Mouse World Pos: ", world_pos))


func _input(event) -> void:
	if event is InputEventMouseMotion:
		var camera = get_viewport().get_camera()
		if camera:
			var ray_length = 1000
			var mouse_pos = get_viewport().get_mouse_position()
			var from = camera.project_ray_origin(mouse_pos)
			var to = from + camera.project_ray_normal(mouse_pos) * ray_length
			var space_state = camera.get_world().get_direct_space_state()
			var result = space_state.intersect_ray(from, to)
			if result.has("position"):
				world_pos = result.position
				return
		world_pos = Vector3.ZERO
