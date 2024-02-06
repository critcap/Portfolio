class_name FieldView
extends ZoneView

enum PlayerIndex {PLAYER, ENEMY}
export (int) var owner_index: int 

# * Method Overrides
func card_entered(area: Area2D) -> void:
	var view = area.owner
	if view.card.owner_index != owner_index:
		return
	view.rest_point = global_position
	cards[view.get_instance_id()] = view
	update_card_position()


func card_exited(area: Area2D) -> void:
	var view = area.owner
	if view.card.owner_index != owner_index:
		return
	if cards.has(view.get_instance_id()):
		cards.erase(view.get_instance_id())
	view.zone = null
	update_card_position()


func set_cards_position(_useless = 0) -> void:
	for card in get_unselected_cards():
		if card.get_node("Area2D").get_overlapping_areas().size() > 1:
			for area in card.get_node("Area2D").get_overlapping_areas():
				if area.owner is HandView: 
					return
		
		card.rest_point.y = global_position.y
		card.rest_point.x = global_position.x + CARD_SIZE * card.zone_index
		card.rest_point.x = card.rest_point.x - (80 * (get_cards().size() -1 ))

func update_card_zone():
	for view in get_unselected_cards():
		view.card.zone = Zones.FIELD
		

func get_cards() -> Array:
	var out = []
	for area in $Area2D.get_overlapping_areas():
		var view = area.owner
		if view.card.owner_index == owner_index:
			if view.card.zone != Zones.GRAVEYARD:
				out.append(view)
	return out

func get_cards_sorted() -> Array:
	var out = get_cards()
	out.sort_custom(ZoneView, "sort_for_positions")
	return out
	
