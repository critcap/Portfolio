extends Spatial

var direction


func set_direction(new_direction: int):
	var arrows = get_children()
	if direction != null:
		var mat = arrows[direction].get_surface_material(0)
		mat.set_shader_param("active", false)

	direction = new_direction
	var mat = arrows[direction].get_surface_material(0)
	mat.set_shader_param("active", true)
