class_name PlayerAvatarView
extends Control


onready var avatar: TextureRect = $TextureRect
onready var health: Label = $Panel/Label
onready var hit_target: Position2D

var player: PlayerBase

func _ready() -> void:
	GlobalSignals.connect("perform_damage_event", self, "on_perform_damage_event")



func set_avatar(_player: PlayerBase) -> void:
	player = _player
	health.text = str(_player.toughness)
	#avatar.texture =
	if _player.index == PlayerIndex.PLAYER:
		hit_target = $TargetPlayer
	else:
		hit_target = $TargetEnemy

func on_perform_damage_event(event: GameEvent) -> void:
	if !event.targets:
		return
	if event.targets.has(player):
		refresh()
	
func refresh():
	health.text = str(player.toughness)