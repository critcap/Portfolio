class_name ScancodeConverter


static func convert_text_to_scancodes(text: Array) -> Array:
	var scancodes = []
	var space = OS.find_scancode_from_string("Space")
	for word in text:
		for character in word:
			var scancode: int

			if !is_qwerty_layout():
				scancode = _handle_german_layout(character)
				scancodes.append(scancode)
				continue

			scancodes.append(OS.find_scancode_from_string(character))

		scancodes.append(space)

	return scancodes


static func convert_code_to_string(scancode: int) -> String:
	var letter := SpecialUtility.get_umlaut_from_scancode(scancode)
	letter = OS.get_scancode_string(scancode) if letter.empty() else letter
	return letter


static func convert_scancodes_to_text(scancodes: Array) -> Array:
	var text = []
	var space = OS.find_scancode_from_string("Space")
	var word = ""
	for scancode in scancodes:
		if scancode == space:
			text.append(word)
			word = ""
			continue
		var letter := SpecialUtility.get_umlaut_from_scancode(scancode)
		letter = OS.get_scancode_string(scancode) if letter.empty() else letter
		word += letter.to_lower()

	return text


static func _handle_german_layout(character: String) -> int:
	var scancode = OS.find_scancode_from_string(character)
	return scancode if scancode != 0 else SpecialUtility.get_scancode_from_special_string(character)


static func is_qwerty_layout() -> bool:
	return OS.get_latin_keyboard_variant() == "QWERTY" if OS.get_name() != "HTML5" else false
