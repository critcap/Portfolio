extends ListMenu


func setup(list: Array) -> void:
	clear()
	for item in list:
		var test_data := item as TypingTestData
		var entry := Entry.instance() as ListEntry
		add_child(entry)
		entry.setup(test_data.name, test_data.arguments)
		var index = list.find(item)
		entry.connect("pressed", self, "on_item_pressed", [index])
