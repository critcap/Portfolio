class_name TimeAttackTestState
extends BaseTypingTestState

var timer: Timer


func enter() -> void:
	timer = Timer.new()
	add_child(timer)
	.enter()


func connect_signals() -> void:
	.connect_signals()
	timer.connect("timeout", self, "on_test_finished")


func on_test_started() -> void:
	timer.start(owner.typing_test.arguments["size"])


func on_test_finished() -> void:
	var collector := owner.stats_collector as TypingStatsCollector
	collector.time = owner.typing_test.time
	change_state("EndTestState")


func exit() -> void:
	.exit()
	timer.queue_free()
