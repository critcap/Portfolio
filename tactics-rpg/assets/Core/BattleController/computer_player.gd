class_name ComputerPlayer
extends Node


var faction: Faction setget , get_faction
var nearest_enemy: Node


func get_faction() -> Faction:
	return owner.subject.get_node("Faction")


func evaluate() -> TurnSequence:
	var ts = TurnSequence.new()
	ts.ability = owner.subject.get_node("Abilities").get_ability("Attack") as Ability
	ts.target = Targets.ENEMY

	sequence_direction_dependent(ts)

	if ts.ability == null:
		move_toward_opponnent(ts)

	return ts

func sequence_direction_dependent(ts: TurnSequence) -> void:
	#var pawn = owner.subject.get_node("Pawn")
	#var start = pawn.tile
	
	var _move_options = get_move_options()

	find_target_in_reach(ts)
	if ts.attack_location && ts.attack_direction != null:
		return

	var enemies = get_all_enemies()
	
	var viable_targets = []
	for enemy in enemies:
		var pawn = enemy.get_node("Pawn")
		if !is_target_alive(pawn.tile):
			continue
		if get_nearby_tiles(pawn, ts.ability).empty():
			continue
		viable_targets.append(enemy)
	
	if viable_targets.empty():
		ts.ability = null
		ts.target = 0
		return

	viable_targets.sort_custom(Health, "sort_current_health")
	
	var target = viable_targets[0].get_node("Pawn")
	
	var nearby_tiles = get_nearby_tiles(target, ts.ability)
	nearby_tiles.sort_custom(self, "sort_tile_distance")
	ts.move_location = nearby_tiles[0]

	var attack_direction: Vector3 = target.tile.position
	attack_direction -= ts.move_location.position
	attack_direction.y = 0.0
	ts.attack_direction = Directions.vec3_to_dir(attack_direction)


func find_target_in_reach(ts: TurnSequence) -> void:
	var nearby = get_nearby_tiles(owner.subject.get_node("Pawn"), ts.ability, true)
	var melee_pawns: = []

	for tile in nearby:
		if !tile.content ||!tile.content.owner.get_node("Faction").is_match(self.faction, Targets.ENEMY):
			continue
		if !is_target_alive(tile):
			continue
		melee_pawns.append(tile.content)
	
	if melee_pawns.empty():
		return
	
	ts.attack_location = melee_pawns[0].tile
	ts.attack_direction = get_attack_direction(owner.subject.get_node("Pawn").tile, melee_pawns[0].tile)


func move_toward_opponnent(_ts: TurnSequence) -> void:
	var move_options: = get_move_options()
	find_nearest_enemy()

	if nearest_enemy != null:
		var to_check: Tile = nearest_enemy.get_node("Pawn").tile as Tile
		
		while to_check != null:
			if move_options.has(to_check):
				_ts.move_location = to_check
				return
			
			to_check = to_check.previous
	
	_ts.move_location = owner.subject.get_node("Pawn").tile
	

func get_move_options() -> Array:
	return owner.subject.get_node("Movement").get_tiles_in_range(owner.board)


func find_nearest_enemy(pos_override: Tile = null) -> void:
	nearest_enemy = null
	var pos = pos_override.position if pos_override else owner.subject.get_node("Pawn").tile.position
	owner.board.search_tiles(pos, funcref(self, "extended_search"))


func extended_search(from: Tile, to: Tile) -> bool:
	var jump = owner.subject.get_node("Movement").jump
	if abs(from.position.y - to.position.y) > jump:
		return false
	
	if nearest_enemy == null && to.content != null:

		var other_faction = to.content.owner.get_node("Faction")
		if other_faction != null && self.faction.is_match(other_faction, Targets.ENEMY):
			var pawn = other_faction.owner.get_node("Pawn") as Actor

			if is_target_alive(to):
				nearest_enemy = pawn.owner
				return true;

	return nearest_enemy == null


func get_all_enemies() -> Array:
	var output = []
	for unit in owner.units:
		if unit.get_node("Faction").is_match(self.faction, Targets.ENEMY):
			output.append(unit)
	
	return output
	

func get_nearby_tiles(pawn: Actor, ability: Ability, ignore_pf: = false) -> Array:
	var filtered = []
	
	for dir in range(0, 4):
		var anb = owner.board.get_pf_tiles(pawn.tile.position + Directions.dir_to_vec3(dir))
		if anb.empty():
			continue
			
		for nb in anb:
			if !nb.previous && !ignore_pf:
				continue
			if abs(nb.position.y - pawn.tile.position.y) > ability.ability_range.vertical:
				continue
			filtered.append(nb)
		
	return filtered


func get_attack_direction(from: Tile, to: Tile) -> int:
	var attack_direction: Vector3 = to.position
	attack_direction -= from.position
	attack_direction.y = 0.0
	return Directions.vec3_to_dir(attack_direction)


func is_target_alive(tile: Tile) -> bool:
	if tile.content == null:
		return false
	
	var health = tile.content.owner.get_node("Health")
	return health.current > health.minhp


static func sort_tile_distance(a, b) -> bool:
		if a.distance < b.distance:
			return true
		return false
