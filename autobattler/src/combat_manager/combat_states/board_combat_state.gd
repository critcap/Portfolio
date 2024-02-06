class_name BoardCombatState
extends CombatState

var button_start_battle: Button
var tween: Tween

func _enter() -> void:
	tween = Tween.new()
	add_child(tween)
	button_start_battle = owner.gui.get_node("ButtonStartBattle")
	button_start_battle.connect("pressed", self, "start_combat")	
	tween.interpolate_property(button_start_battle, "modulate:a", 0 , 1, 0.25,Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	button_start_battle.visible = true

func _disconnect_signals() -> void:
	button_start_battle.disconnect("pressed", self, "start_combat")

func on_put_all_cards() -> void:
	var hand = owner.board.player_views[self.player.index].get_node("HandView")
	var field = owner.board.player_views[self.player.index].field

	for card in hand.get_cards():
		card.global_position = field.global_position
		card.rest_point = field.global_position


func start_combat() -> void:
	yield(get_tree(), "idle_frame")
	tween.reset_all()
	tween.interpolate_property(button_start_battle, "modulate:a", 1 , 0, 2,Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	owner.change_state("PrepareCombatState")
	yield(tween, "tween_all_completed")
	button_start_battle.visible = false
	button_start_battle.pressed = false


