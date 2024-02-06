extends AnimationPlayer

onready var card_body = $"../CardBody"

const PRE_ATTACK_POSITION: = Vector2(0, -100)

var _useless 

func _ready() -> void:
	owner.connect("card_selected",self,"focus_card")
	owner.connect("card_unselected",self,"unfocus_card")

func attack_target(target_position) -> void:
	var target_local_space: Vector2 = target_position - owner.global_position
	
	var target_rotation: float = (owner.global_position - target_position).angle()
	target_rotation = rad2deg(target_rotation)
	target_rotation += 90.0 * target_local_space.normalized().y
	var attack_animation: Animation = get_animation("attack")
	
	attack_animation.track_set_key_value(0,0, PRE_ATTACK_POSITION)
	attack_animation.track_set_key_value(0,1, target_local_space)
	attack_animation.track_set_key_value(0,2, Vector2.ZERO)

	attack_animation.track_set_key_value(1,0, 0)
	attack_animation.track_set_key_value(1,1, target_rotation)
	play("attack")



func play_prepare_attack() -> void:
	var prepare: Animation = get_animation("prepare_attack")
	prepare.track_set_key_value(0,0, Vector2.ZERO)
	prepare.track_set_key_value(0,1, PRE_ATTACK_POSITION)
	play("prepare_attack")


func focus_card() -> void:

	play("focus")
	pass

func unfocus_card() -> void:
	play("unfocus")
	pass