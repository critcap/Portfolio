class_name SelectTargetState
extends BattleState

var tiles: Array
var pawn: Actor

var gui

onready var trajectory: LineRenderer = LineRenderer.new()

func _ready():
	add_child(trajectory)

func enter() -> void:
	.enter()
	gui = owner.get_node("TargetDisplay")

	pawn = self.subject.get_node("Pawn")
	var ranger = self.ability.ability_range
	ranger.pawn = pawn

	tiles = ranger.get_tiles_in_range(self.board)
	select_tiles()

	if ranger.directional:
		owner.cursor.locked = true

	if is_ai_turn():
		if ranger.directional:
			change_direction(self.turn.sequence.attack_direction)
		else:
			owner.cursor.position = self.turn.sequence.attack_location.position
		yield(get_tree().create_timer(.5), "timeout")
		on_accept()


func connect_signals() -> void:
	.connect_signals()
	if is_projectile_skill(self.ability):
		owner.cursor.connect("tile_changed", self, "update_trajectory")


func update_trajectory(tile: Tile) -> void:
	if !tiles.has(tile):
		return
	
	var projectile = self.ability.get_node("Projectile")
	var start = pawn.get_node("AbilityAnchor").global_transform.origin
	var simulated_trajectory = yield(projectile.simulate_projectile(tile, start), "completed")
	trajectory.points = simulated_trajectory.points
	trajectory.visible = true


func unhandled_input(event) -> void:
	.unhandled_input(event)

	if !self.ability.ability_range.directional:
		return

	if event.is_action_pressed("camera_forward") || event.is_action_pressed("ui_up"):
		change_direction(Directions.NORTH)
	elif event.is_action_pressed("camera_backward") || event.is_action_pressed("ui_down"):
		change_direction(Directions.SOUTH)
	elif event.is_action_pressed("camera_right") || event.is_action_pressed("ui_right"):
		change_direction(Directions.EAST)
	elif event.is_action_pressed("camera_left") || event.is_action_pressed("ui_left"):
		change_direction(Directions.WEST)


func change_direction(dir: int) -> void:
	var pawn = self.subject.get_node("Pawn")
	if pawn.direction == dir:
		return
	pawn.direction = dir
	tiles = self.ability.ability_range.get_tiles_in_range(self.board)
	select_tiles()


func on_accept():
	var area = self.ability.area
	var tiles_in_area = area.get_tiles_in_area(self.board, self.tile.position)

	for t in tiles_in_area:
		if t.content:
			self.turn.targets.append(t)

	if !self.turn.targets.empty():
		owner.change_state("PerformAbilityState")


func on_cancel():
	owner.change_state("SelectCommandState")


func select_tiles() -> void:
	self.board.deselect_tiles()
	self.board.select_tiles(tiles)


func is_projectile_skill(ability: Ability) -> bool:
	return ability.has_node("Projectile")


func exit():
	.exit()
	owner.cursor.locked = false
	trajectory.visible = false
	self.board.deselect_tiles()
