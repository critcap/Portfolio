class_name Visualizer
extends Node


static func visualize_input(scancode: int) -> String:
	var key = SpecialUtility.get_umlaut_from_scancode(scancode)
	return key if key.length() == 1 else _parse_modifier_key_as_symbol(key)


# More Symbols
static func _parse_modifier_key_as_symbol(key_string: String) -> String:
	key_string = key_string.to_lower()
	match key_string:
		"control":
			return "^"
		"shift":
			return "⇧"
		"command":
			return "⌘"
		"alt", "options", "meta":
			return "⌥"
		"space":
			return "␣"
		_:
			return ""
