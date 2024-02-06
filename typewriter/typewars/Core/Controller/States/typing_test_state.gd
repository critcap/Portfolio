class_name BaseTypingTestState
extends TestState

var validator: Validator
var allow_input: bool


func _ready():
	can_quit = true
	can_reload = true


func enter() -> void:
	can_quit = true
	can_reload = true

	validator = owner.validator
	owner.ui_prompt.visible = true
	.enter()


func connect_signals() -> void:
	.connect_signals()
	validator.connect("started", self, "on_test_started")
	validator.connect("finished", self, "on_test_finished")


func on_test_started() -> void:
	pass


func on_test_finished() -> void:
	pass


func unhandled_input(event):
	.unhandled_input(event)
	if !(event is InputEventKey):
		return

	var key_event := event as InputEventKey
	# short for quickly ending tests in debug mode
	if OS.is_debug_build() && key_event.scancode == KEY_ENTER && key_event.control:
		on_test_finished()
		return
	# filters cases of hold down keys
	if !key_event.pressed || key_event.echo:
		return
	validator.validate(event)


func exit() -> void:
	.exit()
	owner.ui_help.visible = false
	owner.ui_prompt.reset()
	owner.ui_prompt.visible = false
