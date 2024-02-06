class_name PlayerView
extends Node




var player: PlayerBase
var avatar: PlayerAvatarView
var hand: HandView
var field: FieldView

func _ready() -> void:
	avatar = $PlayerAvatar
	field = $FieldView


func set_player(_player: PlayerBase) -> void:
	player = _player
	avatar.set_avatar(player)
	field.owner_index = _player.index
	if player.index == PlayerIndex.PLAYER:
		hand = $HandView

func get_card_view(card: GameCard):
	if !get_tree().has_group(Groups.card_views):
		return
	for view in get_tree().get_nodes_in_group(Groups.card_views):
		if view.card.id == card.id:
			return view


