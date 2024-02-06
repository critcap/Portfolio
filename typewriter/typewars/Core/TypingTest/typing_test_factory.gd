class_name TypingTestFactory
extends Node


static func assemble_test(raw: TypingTestData, args: Dictionary, tests: Dictionary) -> TypingTest:
	var test = TypingTest.new()
	test.arguments = args if args else {}
	test.name = raw.name if raw.name != "" else "Test"

	if raw.data is Array && !raw.data.empty():
		return generate_random_test(raw.data, test, tests, raw.data[0].length() >= 2)
	elif raw.data is String and (raw.data != ""):
		var length = int(test.time / 5) if test.mode == TypingTestModes.TIME_ATTACK else test.length
		test.content = generate_content_from_string(raw.data, length)
		return test

	push_error("No data found for test: " + test.name)
	return test


# region String Content Generation
static func generate_content_from_string(data: String, repeats: int = 0) -> PoolStringArray:
	data = data.to_lower()
	var content := data.split(" ")
	if repeats > 0:
		for _i in range(repeats):
			content += data.split(" ")
	return content


# endregion

# region Random Test Generation


static func generate_random_test(
	data: PoolStringArray, test: TypingTest, tests: Dictionary, is_words: bool = false
) -> TypingTest:
	if !is_words:
		data = combine_contents(data, test.arguments, tests)
		var new_data = (
			data
			if is_qwerty_layout()
			else Qwertzyfier.qwertzify(data.join(" ")).split(" ")
		)
		var min_size = PlayerManager.settings.factory_min_size
		var max_size = PlayerManager.settings.factory_max_size
		test.content = generate_random_test_content(new_data, test.length, min_size, max_size)
	else:
		test.content = _generate_common_word(data, test.length)
	return test


static func generate_random_test_content(data: Array, l: int, _min: int, _max: int) -> PoolStringArray:
	seed(OS.get_ticks_msec() + OS.get_unix_time())
	var words = []
	for _i in range(l):
		words.append(_generate_word(data, _min, _max).to_lower())
	return words


static func _generate_word(data: Array, min_l, max_l) -> String:
	var word = ""
	while true:
		if is_word_finished(word, min_l, max_l):
			return word
		randomize()
		word += data[randi() % data.size()]

	return word


static func _generate_common_word(data: Array, l: int) -> PoolStringArray:
	var words = []
	for _i in range(l):
		randomize()
		var word := data[randi() % data.size()] as String
		words.append(word.to_lower())
	return words as PoolStringArray


static func is_word_finished(word: String, min_l, max_l) -> bool:
	randomize()
	var randomf: float = randf()
	if randomf < 0.2:
		return word.length() >= min_l
	elif randomf < 0.8:
		return word.length() >= min_l + 1 && word.length() <= max_l - 1
	elif randomf >= 0.8:
		return word.length() >= max_l
	else:
		return false


# endregion


# region Utils
static func is_qwerty_layout() -> bool:
	return OS.get_latin_keyboard_variant() == "QWERTY" if OS.get_name() != "HTML5" else false


static func combine_contents(data: PoolStringArray, args: Dictionary, tests: Dictionary) -> PoolStringArray:
	if !args.has("combine") || args["combine"].empty() || tests == null || tests.keys().empty():
		return data
	data = data as PoolStringArray
	for i in args["combine"]:
		var test_data = tests[i].data if tests.has(i) else []
		data += test_data as PoolStringArray
	return data

# endregion
