extends Label

export (Color) var color_base
export (Color) var color_damaged
export (Color) var color_buffed

enum {BASE, BUFFED, DAMAGED}
var state: int

func refresh() -> void:
	match state: 
		BUFFED:
			set("custom_colors/font_color", color_buffed)
		DAMAGED:
			set("custom_colors/font_color", color_damaged)
		_:
			set("custom_colors/font_color", color_base)