class_name CameraRigController
extends Spatial

########################
# SIGNALS
########################
signal camera_moved(new_location)
signal camera_rotated

########################
# EXPORT PARAMS
########################
# movement
export(float, 0, 100, 0.5) var movement_speed = 20
# zoom
export(float, 0, 100, 0.5) var min_zoom = 3
export(float, 0, 999, 0.5) var max_zoom = 20
export(float, 0, 100, 0.5) var zoom_speed = 20
export(float, 0, 1, 0.05) var zoom_speed_damp = 0.8
# rotation
export(int, 0, 90) var min_elevation_angle = 10
export(int, 0, 90) var max_elevation_angle = 80
export(float, 0, 100, 0.5) var rotation_speed = 20
# pan
export(float, 0, 10, 0.5) var pan_speed = 2
# flags
export var allow_wasd_movement: bool = true
export var allow_zoom: bool = true
export var zoom_to_curser: bool = true
export var allow_rotation: bool = true
export var inverted_y: bool = false
export var allow_pan: bool = true
export var use_one_way_movement: bool = true
export var follow: bool = true
export(float, 0.0, 1.0, 0.1) var follow_speed: float = 0.2
export(NodePath) var follow_target

########################
# PARAMS
########################
# movement
onready var tween = $Tween
var _lock_movement: bool = false
# zoom
onready var camera = $Elevation/Camera
var zoom_direction = 0
# rotation
onready var elevation = $Elevation
var is_rotating = false
# pan
var is_panning = false

var follow_target_last_position := Vector3.ZERO
# click position
const RAY_LENGTH = 1000
const GROUND_PLANE = Plane(Vector3.UP, 0)
var _last_mouse_position = Vector2()

########################
# OVERRIDE FUNCTIONS
########################


func _process(delta: float) -> void:
	if _lock_movement:
		return
	#_move(delta)
	_rotate_and_elevate(delta)
	_zoom(delta)
	_pan(delta)
	_follow(delta)


# TODO use delta for fps independed speed
func _follow(_delta: float) -> void:
	if !follow_target || !follow || is_panning:
		return
	var t_node = get_node(follow_target)
	if t_node.translation == self.translation || t_node.translation == follow_target_last_position:
		return
	follow_target_last_position = t_node.translation
	tween.interpolate_property(
		self,
		"translation",
		translation,
		t_node.translation,
		follow_speed,
		Tween.TRANS_QUART,
		Tween.EASE_OUT
	)
	tween.start()


func _input(event: InputEvent) -> void:
	# zoom
	if event.is_action_pressed("camera_zoom_in"):
		zoom_direction = -1
	if event.is_action_pressed("camera_zoom_out"):
		zoom_direction = 1
	# rotation
	if event.is_action_pressed("camera_rotate"):
		is_rotating = true
		_last_mouse_position = get_viewport().get_mouse_position()
	if event.is_action_released("camera_rotate"):
		is_rotating = false
	# pan
	if event.is_action_pressed("camera_pan"):
		tween.stop(self, "translation")
		is_panning = true
		_last_mouse_position = get_viewport().get_mouse_position()
	if event.is_action_released("camera_pan"):
		is_panning = false
	elif event.is_action_pressed("camera_rotate_clockwise"):
		_rotate_absolut(-90)
	elif event.is_action_pressed("camera_rotate_counterclock"):
		_rotate_absolut(90)


##############################
# MOVEMENT FUNCTIONS
##############################
func _move(delta: float) -> void:
	if not allow_wasd_movement:
		return
	var velocity = _get_desiered_velocity()
	if use_one_way_movement:
		velocity = get_one_dir_velocity(velocity)
	velocity *= delta * movement_speed
	GUI.label(str("velocity", velocity, "| velo normalized: ", velocity.normalized()))
	_translate_position(velocity)


func get_one_dir_velocity(velocity: Vector3) -> Vector3:
	var min_a = velocity.min_axis()
	var max_a = velocity.max_axis()
	var axis = max_a if velocity[max_a] > abs(velocity[min_a]) else min_a
	var output = Vector3.ZERO
	output[axis] = velocity[axis]
	return output


func _rotate_and_elevate(delta: float) -> void:
	if not allow_rotation or not is_rotating:
		return
	var mouse_speed = _get_mouse_speed()
	_rotate(mouse_speed.x, delta)
	_elevate(mouse_speed.y, delta)


func _rotate(amount: float, delta: float) -> void:
	rotation_degrees.y += clamp(rotation_speed * amount * delta, -360.0, 360.0)
	if abs(rotation_degrees.y) > 360.0:
		rotation_degrees.y = 0.0
	emit_signal("camera_rotated")


func _rotate_absolut(amount: float) -> void:
	rotation_degrees.y += amount
	if abs(rotation_degrees.y) > 360.0:
		rotation_degrees.y = 0.0 + (abs(rotation_degrees.y) - 360) * sign(rotation_degrees.y)
	emit_signal("camera_rotated")


func _elevate(amount: float, delta: float) -> void:
	var new_elevation = elevation.rotation_degrees.x
	if inverted_y:
		new_elevation += rotation_speed * amount * delta
	else:
		new_elevation -= rotation_speed * amount * delta
	elevation.rotation_degrees.x = clamp(new_elevation, -max_elevation_angle, -min_elevation_angle)


func _zoom(delta: float) -> void:
	if not allow_zoom or not zoom_direction:
		return
	var new_zoom = clamp(
		camera.translation.z + zoom_direction * zoom_speed * delta, min_zoom, max_zoom
	)
	var pointing_at = _get_ground_position()
	camera.translation.z = new_zoom
	# pan if need to zoom to curser
	if zoom_to_curser and pointing_at != null:
		_realign_camera(pointing_at)
	# faze out speed
	zoom_direction *= zoom_speed_damp
	if abs(zoom_direction) < 0.0001:
		zoom_direction = 0


func _pan(delta: float) -> void:
	if not allow_pan or not is_panning:
		return
	# get mouse speed
	var mouse_speed = _get_mouse_speed()
	# transform to velocity
	var velocity = (
		(global_transform.basis.z * mouse_speed.y + global_transform.basis.x * mouse_speed.x)
		* delta
		* pan_speed
	)
	# translate
	_translate_position(-velocity)


func _jump_to_position(locaiton: Vector3, duration: float) -> void:
	_lock_movement = true

	tween.stop(self, "translation")
	tween.interpolate_property(
		self, "translation", translation, locaiton, duration, Tween.TRANS_SINE, Tween.EASE_OUT
	)
	tween.start()
	yield(tween, "tween_completed")
	_lock_movement = false


##############################
# HELPERS
##############################
func _end_jump() -> void:
	_lock_movement = false


func _get_mouse_speed() -> Vector2:
	# calculate speed
	var current_mouse_pos = get_viewport().get_mouse_position()
	var mouse_speed = current_mouse_pos - _last_mouse_position
	# update last click position
	_last_mouse_position = current_mouse_pos
	# return speed
	return mouse_speed


func _realign_camera(point: Vector3) -> void:
	var new_position = _get_ground_position()
	if new_position == null:
		return
	_translate_position(point - new_position)


func _translate_position(v: Vector3) -> void:
	translation += v
	emit_signal("camera_moved", translation)


func _get_ground_position() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_from = camera.project_ray_origin(mouse_pos)
	var ray_to = ray_from + camera.project_ray_normal(mouse_pos) * RAY_LENGTH
	return GROUND_PLANE.intersects_ray(ray_from, ray_to)


func _get_desiered_velocity() -> Vector3:
	var velocity = Vector3()
	# dont move if panning
	if is_panning:
		return velocity
	# get input
	if Input.is_action_pressed("camera_forward"):
		velocity -= transform.basis.z
	if Input.is_action_pressed("camera_backward"):
		velocity += transform.basis.z
	if Input.is_action_pressed("camera_left"):
		velocity -= transform.basis.x
	if Input.is_action_pressed("camera_right"):
		velocity += transform.basis.x
	return velocity.normalized()


func freeze_camera() -> void:
	_lock_movement = true
	allow_zoom = false
	allow_rotation = false
	allow_pan = false


func release_camera() -> void:
	allow_zoom = true
	allow_rotation = true
	allow_pan = true
	_lock_movement = false
