extends Control


func _process(_delta):
	rect_position = get_viewport().get_camera().unproject_position(get_parent().global_transform.origin)
