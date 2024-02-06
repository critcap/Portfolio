class_name PlayerResults
extends TypingStatsResult

var _results: Array
var _is_dirty: bool


func add_result(result: TypingStatsResult) -> void:
	if !result || !result._data:
		print("Error: Invalid result data")
		return

	var data = result._data
	# add timestamp
	data["DATE"] = OS.get_unix_time()
	_results.append(data)
	_is_dirty = true
