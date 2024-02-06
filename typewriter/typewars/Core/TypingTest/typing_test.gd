class_name TypingTest
extends Node

# const DEFAULT_TIME: int = 60
# const DEFAULT_LENGTH: int = 100
# const DEFAULT_MODE: int = 1

var content: PoolStringArray setget set_content, get_content
var scancodes: PoolIntArray
var arguments: Dictionary
var result: TypingStatsResult

# Properties
var mode: int setget , get_mode
var time: int setget , get_time
var length: int setget , get_length

var is_reload: bool


# region setters & getters
func set_content(value) -> void:
	content = value


func get_content() -> PoolStringArray:
	return content


func get_mode() -> int:
	return arguments["mode"]  # if arguments.has("mode") else DEFAULT_MODE


func get_time() -> int:
	if self.mode != 0:
		return 0
	return arguments["size"]  # if arguments.has("size") else DEFAULT_TIME


func get_length() -> int:
	if self.mode != 1:
		return int(212 * 60 / time)  # current world record times time
	return arguments["size"]  # if arguments.has("size") else DEFAULT_LENGTH

# endregion
