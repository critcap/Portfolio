class_name CursorController
extends Node

signal tile_changed(tile)

var position: Vector3 setget set_position
var index: int
var board: Board

# private properties
var locked: bool setget , is_locked


func is_locked() -> bool:
	return locked


func set_position(pos: Vector3) -> void:
	if position == pos:
		return
		
	position = pos

	if !board:
		return
		
	var tile = board.get_tile(position)
	emit_signal("tile_changed", tile)
	$Cursor.translation = tile.translation


func _unhandled_input(event) -> void:
	if is_locked():
		return

	if event.is_action_pressed("cursor_move", true):
		on_cursor_move()

	elif event.is_action_pressed("cursor_vertical", true):
		move_vertical(1)


func on_cursor_move() -> void:
	var velocity = Vector3.ZERO
	velocity = get_velocity_relative_to_camera(velocity)
	velocity = get_mono_directional_velocity(velocity)
	velocity = velocity.round()

	var tiles_at_coord = board.get_pf_tiles(position + velocity)

	if tiles_at_coord.empty():
		return

	var destination: Tile = (
		tiles_at_coord[0]
		if tiles_at_coord.size() < 2
		else get_nearest_tile(tiles_at_coord)
	)

	index = tiles_at_coord.find(destination)
	self.position = destination.position


# cycles through overlapping tiles on the same XZ coordinates
func move_vertical(direction: int) -> void:
	var tiles = board.get_pf_tiles(position)
	if tiles.size() < 2:
		return
	index = wrapi(index + direction, 0, tiles.size())
	self.position = tiles[index].position


func get_velocity_relative_to_camera(_velocity: Vector3) -> Vector3:
	var camera_transform = get_viewport().get_camera().owner.transform
	if Input.is_action_pressed("camera_forward"):
		_velocity -= camera_transform.basis.z
	if Input.is_action_pressed("camera_backward"):
		_velocity += camera_transform.basis.z
	if Input.is_action_pressed("camera_left"):
		_velocity -= camera_transform.basis.x
	if Input.is_action_pressed("camera_right"):
		_velocity += camera_transform.basis.x
	return _velocity


func get_mono_directional_velocity(_velocity: Vector3) -> Vector3:
	if abs(_velocity.x) == abs(_velocity.z):
		_velocity = _velocity.rotated(Vector3(0, 1, 0), -0.00001)
	var replace = Vector3.ZERO
	var axis_index = _velocity.abs().max_axis()
	replace[axis_index] = _velocity[axis_index]
	return replace


func get_nearest_tile(tiles: Array) -> Tile:
	return (
		tiles[0]
		if abs(tiles[0].position.y - position.y) < abs(tiles[1].position.y - position.y)
		else tiles[1]
	)
