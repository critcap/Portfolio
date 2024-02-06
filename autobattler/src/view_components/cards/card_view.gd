class_name CardView
extends Node2D

signal card_selected
signal card_unselected
signal damage_key_frame

onready var animation = $AnimationPlayer
var card: GameCard 

var selected = false 
var zone_index setget _set_zone_index, _get_zone_index
var zone: Area2D 
var rest_point: = Vector2.ZERO 
var clicked_point: = Vector2.ZERO

# * public methods

func set_card(_card: GameCard) -> void:
	card = _card
	$CardBody.refresh()

# * private methods

func _set_zone_index(value:int) -> void:
	card.zone_index = value
	$CardBody/Control/Label.text = str(value)

func _get_zone_index() -> int:
	return card.zone_index
 
func _on_Control_gui_input(_event):
	if owner.player.index == card.owner_index:	
		if Input.is_action_just_pressed("left_click"):	
			clicked_point = get_local_mouse_position()
			selected = true
			emit_signal("card_selected")

func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position() - clicked_point, 20 * delta)
	elif global_position != rest_point: 
		global_position = lerp(global_position, rest_point, 25 *delta)
	
func _input(event):
	if event is InputEventMouseButton: 
		if event.button_index == BUTTON_LEFT and not event.pressed:
			if selected:
				emit_signal("card_unselected")
			selected = false
			#clicked_point = Vector2.ZERO
			


