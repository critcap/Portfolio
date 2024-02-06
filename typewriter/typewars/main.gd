extends Node


func _ready():
	var controller = $TestController
	controller.ui_select = get_node("%TestSelectionMenu")
	controller.ui_statistics = get_node("%StatisticsMenu")
	controller.ui_prompt = get_node("%InputPrompt")
	controller.ui_help = $"%InputPromptTutorial"

	controller.start()


func _unhandled_key_input(event):
	if event.is_action_pressed("shader_toggle"):
		$PostProcessing.visible = !$PostProcessing.visible
