extends Node


func _ready():
	# TODO (critcap) create load function inside board.gd
	var board = $BattleController/Board
	board.cell_size = Vector3(1,1,1)
	board._tiles = BoardGenerator.generate_board(Vector2(5,5))
	$BattleController.start("InitBattleState")
