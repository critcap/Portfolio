extends Node

export(Resource) var raw


func _ready():
	# TODO (critcap) create load function inside board.gd
	var board = $BattleController/Board
	raw = preload("res://_developer/CastleMap/Castle_Board.tres")
	board.cell_size = raw.size
	board._tiles = BoardGenerator.generate_from_raw(raw.tiles)
	$BattleController.start("InitBattleState")

func _gui(_delta) -> void:
	if GUI.button("kill_all_enemies"):
		var bc = $BattleController
		for unit in bc.units:
			if unit.get_node("Faction").type == Factions.ENEMY:
				unit.get_node("Health").current = -2
			
		if bc.current_state.is_battle_over():
			bc.current_state.process_battle_end()
	if GUI.button("kill_hero"):
		$BattleController.units[0].get_node("Health").current = 0
	if GUI.button("revive_hero"):
		$BattleController.units[0].get_node("Health").current = 30
	if GUI.button("kill_enemy"):
		$BattleController.units[4].get_node("Health").current = 0
