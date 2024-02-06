class_name SpriteAnimationController
extends AnimationPlayer


var current: String = "walk"
var is_directional: bool = true

var direction: int setget set_direction


func _ready() -> void:
	var cam = get_viewport().get_camera().owner as CameraRigController
	cam.connect("camera_rotated", self, "play_animation", [current, is_directional])


func set_direction(value: int) -> void:
	if value == direction:
		return
	direction = value
	play_animation(current, is_directional)


func play_animation(name: ="", directional: = true, custom_blend: = -1, custom_speed: = 1.0, from_end: = false) -> void:	
	var dir_name = name
	if directional:
		dir_name = get_animation_direction(name)

	if !has_animation(dir_name):
		return
	
	current = name
	is_directional = directional

	play(dir_name, custom_blend, custom_speed, from_end)
	

func get_animation_direction(name: String) -> String:
	var all_animations = get_animation_list()
	
	if all_animations.empty():
		return ""
	
	var relative_direction = get_relative_direction()
	var lookup_name: String = str(name + "_" + dir_to_string(relative_direction))
	
	return lookup_name if has_animation(lookup_name) else name


func get_relative_direction() -> int:
	if !get_viewport():
		return 0

	var camera = get_viewport().get_camera().owner as CameraRigController
	var rotation_y = camera.rotation_degrees.y

	if rotation_y < 0.0:
		rotation_y = rotation_y + 360

	var index = int(floor(rotation_y) / 90)
	return wrapi(direction - index, 0, 4)


static func dir_to_string(dir: int) -> String:
	match dir:
		1:
			return "east"
		2:
			return "north"
		3:
			return "west"
		0, _:
			return "south"
