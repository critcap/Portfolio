class_name AttackView
extends BaseView

func _ready() -> void:
	GlobalSignals.connect("prepare_attack_event", self, "on_prepare_attack_event")
	GlobalSignals.connect("perform_attack_event", self, "on_perform_attack_event")

func on_prepare_attack_event(event) -> void:
	event.perform.viewer = funcref(self, "OnAttackViewer")


func on_perform_attack_event(event: AttackEvent) -> void:
	var returner = ReturnEvent.new()
	returner.subject = event.attacker
	returner.perform.viewer = funcref(self, "AttackReturnViewer")
	returner.priority = -1
	owner.get_node("EventSystem").add_reaction(returner)


func OnAttackViewer(event: AttackEvent, handler: FuncRef) -> void:
	var attacker = event.attacker
	var target = event.target
	var target_view = get_view_component(target)
	var attacker_view = get_view_component(attacker)

	attacker_view.animation.play_prepare_attack()
	yield(attacker_view.animation, "animation_finished")
	attacker_view.animation.attack_target(target_view.global_position)
	yield(attacker_view, "damage_key_frame")
	handler.call_func()
	#yield(attacker_view.animation, "animation_finished")
	return true


func AttackReturnViewer(event: ReturnEvent, _handler: FuncRef) -> void:
	var subject = event.subject
	var view = get_view_component(subject)
	var body = view.get_node("CardBody")
	var tweener = Tween.new()
	add_child(tweener)
	var anim_length: = 0.4
	tweener.interpolate_property(body, "position", body.position, Vector2.ZERO, anim_length, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tweener.interpolate_property(body, "rotation", body.rotation, 0.0, anim_length, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tweener.start()
	yield(tweener, "tween_all_completed")
	tweener.queue_free()
	return false