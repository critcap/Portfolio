class_name ZoneView
extends Node2D

export (int) var card_spacing: = 10

var cards: Dictionary = {}

# * Gamesettings
const CARD_SIZE: = 160
const SPACE: = 10

func _ready():
	$Area2D.connect("area_entered", self, "card_entered")
	$Area2D.connect("area_exited", self, "card_exited")


func _physics_process(_delta) -> void:
	update_card_position()
	#pass

func card_entered(area: Area2D) -> void:
	var card = area.owner
	card.rest_point = global_position
	update_card_position()
	pass

func card_exited(area: Area2D) -> void:
	var card = area.owner
	card.zone = null
	update_card_position()


func update_card_position(_useless = 0) -> void:
	var _cards = get_cards()
	_cards.sort_custom(self, "sort_for_positions")
	for card in _cards: 
		card.zone_index = _cards.find(card)
	update_card_zone() 
	set_cards_position()

func set_cards_position(_useless = 0) -> void:
	for card in get_unselected_cards():
			var combined_size = CARD_SIZE + card_spacing
			card.rest_point.y = global_position.y
			card.rest_point.x = global_position.x + combined_size * card.zone_index
			card.rest_point.x = card.rest_point.x - ((combined_size/2) * ($Area2D.get_overlapping_areas().size() -1 ))

func update_card_zone() -> void:
	pass


func get_cards() -> Array:
	var out = []
	for area in $Area2D.get_overlapping_areas():
		out.append(area.owner)
	return out

func get_unselected_cards() -> int:
	var out = []
	for view in get_cards():
		if !view.selected:
			out.append(view)
	return out


static func sort_for_positions(a,b):
	if a.is_inside_tree() && b.is_inside_tree():
		if a.global_position.x < b.global_position.x:
			return true
		return false	 
	
