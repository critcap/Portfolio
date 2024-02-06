class_name GUIOptions
extends OptionButton

var base = GUIBase.new(self, "item_selected")
var options = []

func set_options(_options):
	if options != _options:
		options = _options
		clear()
		for text in options:
			add_item(str(text))