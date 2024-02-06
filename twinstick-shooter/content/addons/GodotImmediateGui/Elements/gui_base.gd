class_name GUIBase

var node
var changed: bool
var defs = {}
var edited = []


func _changed(_v = null):
	changed = true


func get_changed():
	if changed:
		changed = false
		return true
	return false


func _init(_node: Control, _signal = null):
	node = _node
	if _signal != null:
		node.connect(_signal, _changed)


func set_property(p, v):
	if !defs.has(p):
		defs[p] = node.get(p)
	edited.append(p)
	node.set(p, v)


func revert():
	for p in edited:
		var def = defs.get(p)
		if node.get(p) != def:
			node.set(p, def)
	edited.clear()


func add_template(template: Dictionary) -> GUIBase:
	return self
	pass
