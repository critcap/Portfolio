extends Node


var map: Node
var player: PlayerBase
var enemy: PlayerBase


func _ready():
	create_game_objects()	
	prepare_combat()
	yield(get_tree().create_timer(0.5), "timeout")
	$CombatManager.start()


func create_game_objects() -> void:
	player = create_player()
	enemy = create_player()


func prepare_combat() -> void:
	var combat_manager = $CombatManager
	combat_manager.board = $CombatManager/Board
	combat_manager.add_child(player)
	combat_manager.add_child(enemy)
	player.owner = combat_manager
	enemy.owner = combat_manager
	combat_manager.player = player
	combat_manager.enemy = enemy
	combat_manager.players = {}
	combat_manager.players[PlayerIndex.PLAYER] = player
	combat_manager.players[PlayerIndex.ENEMY] = enemy
	combat_manager.gui = $CombatManager/GUI
	enemy.add_to_group(Groups.players)
	player.add_to_group(Groups.players)


func create_player() -> PlayerBase:
	var p = PlayerBase.new()
	p.add_to_group(Groups.players)
	#add_child(p)
	return p 

func _unhandled_input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		print("hasdas")
		$GUI/StartMenu.open()
