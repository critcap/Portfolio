class_name DamageView
extends BaseView

var DamagePopup = preload("res://src/scenes/cards/DamagePopup.tscn")

func _ready():
	GlobalSignals.connect("prepare_damage_event", self, "on_prepare_damage_event")

func on_prepare_damage_event(event: DamageEvent) -> void:
	if event.targets.size() > 0 && event.viewable:
		event.perform.viewer = funcref(self, "DamagePopupViewer")

func DamagePopupViewer(event: DamageEvent, handler: FuncRef) -> void:
	handler.call_func()
	yield(get_tree(), "idle_frame")
	for target in event.targets:
		var popup = DamagePopup.instance()
		var view = get_view_component(target)
		view.add_child(popup)
		popup.perform_popup(event.amount, "!")
	return true

func get_view_component(target):
	var view = .get_view_component(target)
	if target is GameCard:
		view = view.get_node("CardBody")
	return view
