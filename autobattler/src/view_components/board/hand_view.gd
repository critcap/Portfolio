class_name HandView
extends ZoneView

onready var io = $CardSpawn


func update_card_zone():
	for view in get_unselected_cards():
		view.card.zone = Zones.HAND