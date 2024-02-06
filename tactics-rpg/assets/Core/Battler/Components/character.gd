class_name Character
extends Actor

onready var _sprite: Sprite3D = $_Sprite
onready var _animations: AnimationPlayer = $_Animations
onready var _arrows := $DirectionArrow


func _ready():
	var cam = get_viewport().get_camera().owner as CameraRigController
	cam.connect("camera_rotated", self, "_refresh_sprite_direction")


func set_direction(value: int) -> void:
	.set_direction(value)
	_arrows.set_direction(value)
	_refresh_sprite_direction()


func match_tile() -> void:
	translation = tile.translation
	#_refresh_sprite_direction()


func _refresh_sprite_direction() -> void:
	if !get_viewport():
		return

	var camera = get_viewport().get_camera().owner as CameraRigController

	var rotation_y = camera.rotation_degrees.y

	if rotation_y < 0.0:
		rotation_y = rotation_y + 360

	var index = int(floor(rotation_y) / 90)

	index = wrapi(direction - index, 0, 4)
	_sprite.flip_h = false
	match index:
		0:
			_sprite.flip_h = true
			_animations.play("walk_south")
		1:
			_animations.play("walk_east")
		2:
			_sprite.flip_h = true
			_animations.play("walk_north")
		3:
			_animations.play("walk_west")
