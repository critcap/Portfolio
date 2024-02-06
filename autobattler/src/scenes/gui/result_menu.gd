extends Control

export (Color) var defeat_color: Color
export (Color) var victory_color: Color

onready var result: = $Panel/Label

func player_win() -> void:
	result.text = "Victory!"
	result.set("custom_colors/font_color", victory_color)
	$AnimationPlayer.play("result_win")


func player_lose() -> void:
	result.text = "Defeat!"
	result.set("custom_colors/font_color", defeat_color)
	$AnimationPlayer.play("result_lose")

func is_playing() -> bool:
	return $AnimationPlayer.is_playing()