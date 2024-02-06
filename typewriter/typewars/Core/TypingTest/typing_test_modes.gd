class_name TypingTestModes

enum { TIME_ATTACK, RACE }


static func mode_to_string(mode: int) -> String:
	match mode:
		TIME_ATTACK:
			return "Time Attack"
		RACE:
			return "Type Race"
		_:
			return str(mode)
