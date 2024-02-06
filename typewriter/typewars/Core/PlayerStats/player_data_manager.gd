class_name PlayerDataManager
extends Node

# Singleton that handles the saving and loading of typing test results
# also provides the collected results for further processing

signal changed

# region Properties
const DEFAULT_USERNAME = "local"
const DEFAULT_DIRECTORY = "user://"
const DEFAULT_SETTINGS_FILE = "res://typewars/Levels/TypingTest/default_settings.tres"

# username of the current player
var username: String setget , get_username
# list of results from current player
var results: Array setget , get_results_list
# gets saved player settings
var settings: Settings setget , get_settings

var _data: PlayerData
var _results: Array
var _clear_debug: bool = true

# endregion

# region Public Methods


func get_settings() -> Settings:
	return _data.settings


func get_username() -> String:
	if !_data:
		return ""
	return _data.username


func get_current_user_path() -> String:
	if OS.is_debug_build():
		return str("res://dev/", DEFAULT_USERNAME)
	return str(DEFAULT_DIRECTORY, DEFAULT_USERNAME)


func get_results_list() -> Array:
	if !_data || !_results:
		return []
	return _results.duplicate()


func add_result(test: TypingTest) -> void:
	var result = _ResultUtility.result_to_dict(
		test.result._data, test.name, Time.get_date_string_from_system()
	)
	_results.append(result)
	_save_player_data()


# endregion

# region Private Methods


func _ready():
	# clear player data in debug before player data look up
	if OS.is_debug_build() && _clear_debug:
		_delete_player_data()

	var data: PlayerData = _load_player_data(DEFAULT_USERNAME) as PlayerData
	if !data:
		data = _create_new_player_data(DEFAULT_USERNAME) as PlayerData
	_data = data
	_results = data.results
	emit_signal("changed")


func _load_player_data(_name: String):
	var resource_loader = ResourceLoader
	var player_data: PlayerData
	var path: String = str(get_current_user_path(), ".tres")

	if !resource_loader.exists(path):
		return

	player_data = ResourceLoader.load(path)
	if player_data is PlayerData:
		return player_data


func _create_new_player_data(_user_name) -> PlayerData:
	var player_data = PlayerData.new()
	player_data.username = _user_name
	player_data.results = []
	var default_settings = load(DEFAULT_SETTINGS_FILE) as Settings
	player_data.settings = default_settings if default_settings else Settings.new()

	_save_player_data(player_data)

	return player_data


func _save_player_data(_player_data: PlayerData = _data) -> void:
	if !_player_data:
		print("Error: No PlayerData to save")
		return

	_player_data.results = _results
	var error_code = ResourceSaver.save(str(get_current_user_path(), ".tres"), _player_data, 2)
	if error_code == 0:
		print(str("Save Success"))


func _delete_player_data(_player_data: PlayerData = _data) -> void:
	var path = str(get_current_user_path(), ".tres")
	if ResourceLoader.exists(path):
		var dir = Directory.new()
		dir.remove(path)

	# region user data lookup
	# Not needed at this moment
	# func do_player_data_lookup(path):
	# 	var files = []
	# 	var dir = Directory.new()

	# 	dir.open(path)
	# 	dir.list_dir_begin(true)

	# 	var file := dir.get_next() as String
	# 	while file != "":
	# 		# skip sub directories
	# 		if dir.current_is_dir():
	# 			continue

	# 		# check if its a resource
	# 		var file_type = file.split(".")[-1]
	# 		if !file_type || (file_type != "tres" && file_type != "res"):
	# 			file = dir.get_next()
	# 			continue

	# 		files += [file]
	# 		file = dir.get_next()

	# 	return files
	# endregion


# endregion


class _ResultUtility:
	# Utility class for (de)serialization of TypingTests
	enum { TESTNAME, TIMESTAMP, RESULT }
	const DEFAULT_TESTNAME = "Test"

	# converts the given information into a dictionary, that can be saved in a list
	static func result_to_dict(data: Dictionary, name: String = "", date: String = "") -> Dictionary:
		if data.values().empty():
			print("Error: Invalid result data")
			return {}

		var result_data := {}
		result_data[TESTNAME] = name if !name.empty() else DEFAULT_TESTNAME
		result_data[TIMESTAMP] = date if !date.empty() else Time.get_date_string_from_system()
		result_data[RESULT] = data
		return result_data
