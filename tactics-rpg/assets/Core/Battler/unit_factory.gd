class_name UnitFactory


static func create_unit(faction: int = Factions.NONE) -> Node:
	var unit = Node.new()
	unit.name = str(unit.get_instance_id())

	unit.add_child(_create_pawn(faction))
	unit.add_child(_create_stats())
	unit.add_child(_create_mover(unit))
	unit.add_child(_create_health(unit))
	unit.add_child(_create_faction(faction))
	unit.add_child(_create_driver(unit))
	unit.add_child(_create_status())
	_create_name(unit)
	_create_ability_inventory(unit)

	for c in unit.get_children():
		c.owner = unit
	return unit


static func _create_pawn(faction: int) -> Actor:
	var prefab = load("res://_developer/Common/Character/KnightM/KnightM.tscn")
	var pawn = prefab.instance()
	pawn.name = "Pawn"
	if faction == Factions.ENEMY:
		var sprite: = pawn.get_node("_Sprite") as Sprite3D
		sprite.modulate = Color.red
	return pawn


static func _create_stats() -> Stats:
	var base_stats = load("res://assets/Core/Battler/DT_DefaultStats.tres")
	var stats = Stats.new()
	for key in base_stats.data.keys():
		stats.set_value(key, base_stats.data[key])
	stats.name = "Stats"

	return stats


static func _create_health(unit: Node) -> Health:
	var health = Health.new()
	health._stats = unit.get_node("Stats")
	health.name = "Health"
	health.current = health.maxhp

	var healthbar = unit.get_node("Pawn/HealthBarAnchor/Control/HealthBar")
	healthbar.setup(health)
	return health


static func _create_mover(unit: Node) -> Movement:
	var mover := WalkMovement.new()
	mover.move_range = 6
	mover.jump = 2
	mover.name = "Movement"
	mover.unit = unit.get_node("Pawn")
	return mover


static func _create_ability_inventory(unit: Node) -> void:
		var inventory = AbilityInventory.new()
		var heal = load("res://assets/Abilities/Heal.tscn").instance()
		var attack = load("res://assets/Abilities/Attack.tscn").instance()
		inventory.add_ability(load("res://assets/Abilities/RangeAttack.tscn").instance())
		inventory.add_ability(load("res://assets/Abilities/Frostbolt.tscn").instance())
		inventory.add_ability(heal)
		inventory.add_ability(attack)
		
		for ability in inventory.get_all_abilities():
			ability.subject = unit
			
		inventory.name = "Abilities"
		unit.add_child(inventory)


static func _create_faction(_type: int) -> Faction:
		var _faction = Faction.new()
		_faction.name = "Faction"
		_faction.type = _type
		
		return _faction


static func _create_name(unit: Node) -> void:
		var name_label = unit.get_node("Pawn/HealthBarAnchor/Control/Name")
		unit.connect("renamed", name_label, "on_character_name_changed", [unit])
		
		var _faction = unit.get_node("Faction")
		match _faction.type:
			Factions.NONE:
				unit.name = "Battler"
			Factions.HERO:
				unit.name = "Hero"
			Factions.ENEMY:
				unit.name = "Enemy"
			Factions.NEUTRAL:
				unit.name = "Neutral"


static func _create_driver(unit: Node) -> Driver:
		var driver: = Driver.new()
		driver.name = "Driver"
		var faction_type = unit.get_node("Faction").type
		driver._normal = Drivers.COMPUTER if faction_type == Factions.ENEMY \
										else Drivers.PLAYER
		return driver


static func _create_status() -> Status:
		var status: = Status.new()
		status.name = "Status"
		return status
