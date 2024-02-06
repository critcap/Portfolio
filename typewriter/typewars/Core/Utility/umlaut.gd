class_name SpecialUtility

# physical umlaut scancodes
const CODE_UE = 123  # ü
const CODE_UE_WIN = 59
const CODE_OE = 59  # ö
const CODE_OE_WIN = 96
const CODE_AE = 39  # ä
const CODE_SZ = 45  # ß


static func get_umlaut_from_scancode(scancode: int) -> String:
	if scancode == CODE_UE || (dumb_os() && scancode == CODE_UE_WIN):
		return "ü"
	elif scancode == CODE_OE || (dumb_os() && scancode == CODE_OE_WIN):
		return "ö"
	elif scancode == CODE_AE:
		return "ä"
	return OS.get_scancode_string(scancode)


static func get_scancode_from_special_string(character: String) -> int:
	if character == "ä":
		return CODE_AE
	elif character == "ö":
		return CODE_OE if !dumb_os() else CODE_OE_WIN
	elif character == "ü":
		return CODE_UE if !dumb_os() else CODE_UE_WIN
	elif character == ",":
		return KEY_COMMA
	elif character == ".":
		return KEY_PERIOD
	return 0


static func is_umlaut(character: String) -> bool:
	return get_scancode_from_special_string(character) != 0


static func dumb_os() -> bool:
	match OS.get_name():
		"Windows":
			return true
		_:
			return false
