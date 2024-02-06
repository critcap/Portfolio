extends Node2D

onready var image = $Control/TextureRect setget set_image
func set_image(value: Texture) -> void: image.texture = value

onready var bg = $Control/ColorRect setget set_bg
func set_bg(value: Color) -> void:	bg.color = value

onready var title = $Control/MarginContainer/Title setget set_name
func set_name(value: String) -> void:	title.text = value

onready var power = $Control/Stats/Power/Label setget set_power
func set_power(value: int) -> void:	power.text = str(value) if value != 0 else "0"
	
onready var toughness = $Control/Stats/Toughness/Label setget set_toughness
func set_toughness(value: int) -> void: toughness.text = str(value) if value != 0 else "0"


# * virtual ovverides
func _ready() -> void:
	GlobalSignals.connect("perform_damage_event", self, "on_perform_damage_event")

# * public methods

func on_perform_damage_event(event: DamageEvent) -> void:
	if event.targets.has(owner.card):
		yield(get_tree(), "idle_frame")
		refresh()

func refresh() -> void:
	var card = owner.card
	self.title = card.data.name

	if card.power:
		var power_label = $Control/Stats/Power/Label

		if card.power > card.data.power:
			power_label.state = power_label.BUFFED
		elif card.power < card.data.power:
			power_label.state = power_label.DAMAGED
		else:
			power_label.state = power_label.BASE
		self.power = card.power
		power_label.refresh()
		$Control/Stats/Power.visible = true
	else:
		$Control/Stats/Power.visible = false
	
	if card.toughness:
		var toughness_label = $Control/Stats/Toughness/Label

		if card.toughness > card.data.toughness:
			toughness_label.state = toughness_label.BUFFED
		elif card.toughness < card.data.toughness:
			toughness_label.state = toughness_label.DAMAGED
		else:
			toughness_label.state = toughness_label.BASE
		self.toughness = card.toughness
		toughness_label.refresh()
		$Control/Stats/Toughness.visible = true
	else:
		$Control/Stats/Toughness.visible = false

