class_name EndOfBattleState
extends BattleState

func enter() -> void:
	.enter()

	if is_battle_over():
		if did_player_win():
			print("The Players Party was victorious!")
		else:
			print("The Players Party was defeated!")
		get_tree().quit()