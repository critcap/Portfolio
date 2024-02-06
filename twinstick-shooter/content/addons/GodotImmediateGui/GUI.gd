extends CanvasLayer

var boxes = []
var used = []
var notused = []
var layout := true

@onready var _body := Control.new()
@onready var _layout := VBoxContainer.new()

var _last_control

# TODO add to builder pattern
var _default = {
	Control:
	{
		"size_flags_horizontal": 3,
		"size_flags_vertical": 0,
		"size": Vector2(200,0),
	},
	BaseButton:
	{
		"action_mode": BaseButton.ACTION_MODE_BUTTON_PRESS,
		"mouse_default_cursor_shape": Control.CURSOR_POINTING_HAND,
	},
	ColorPickerButton:
	{
		"rect_min_size": Vector2(20, 20),
	},
}
var property = {}


func clear_default():
	_default.clear()


# warning-ignore:shadowed_variable
func add_default(type, property, value):
	var props = _default.get(type)
	if props == null:
		props = {}
		_default[type] = props
	props[property] = value


# warning-ignore:shadowed_variable
func remove_default(type, property = null):
	var props = _default.get(type)
	assert(props != null, str('There is no default values for type "', type, '"'))
	if property == null:
		_default.erase(type)
		return
	var has_property = props.has(property)
	assert(
		has_property,
		str("Can't remove property \"", property, '" from type "', type, '", property not set')
	)
	if has_property:
		props.erase(property)


func _ready():
	_body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_layout.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_body.set_anchors_and_offsets_preset(Control.PRESET_LEFT_WIDE)
	_layout.set_anchors_and_offsets_preset(Control.PRESET_LEFT_WIDE)
	_layout.size = Vector2(600,1080)
	add_child(_body)
	_body.add_child(_layout)


func _process(delta):
	get_parent().propagate_call("_gui", [delta])

	_layout.move_to_front()
	layout = true
	assert(boxes.size() == 0, "Not all containers are closed. Use GUI.end() to close containers.")
	boxes.clear()

	for c in notused:
		c.queue_free()
	notused.clear()

	var t = notused
	notused = used
	used = t


func printvar(node, v):
	label(str(node.name, " ", "[", node.get_instance_id(), "] ", v, ": ", node.get(v)))


func _get_control(type, text = null):
	var _c
	for c in notused:
		if is_instance_of(c, type):
			_c = c
			c.base.revert()
			notused.erase(c)
			break
	if _c == null:
		_c = type.new()
	used.append(_c)
# warning-ignore:incompatible_ternary
# warning-ignore:incompatible_ternary
	reparentCustom(_c, (_layout if layout else self) if boxes.size() == 0 else boxes[-1])
	if text != null:
		_c.text = str(text)

	_c.size = Vector2.ZERO

	for typeKey in _default.keys():
		if is_instance_of(_c, type):
			var defs = _default[typeKey]
			for p in defs.keys():
				_c.base.set_property(p, defs[p])
	for p in property.keys():
		_c.base.set_property(p, property[p])
	property.clear()

	_last_control = _c
	return _c


func reparentCustom(node, new_parent: Node):
	var p = node.get_parent()
	if p == new_parent:
		node.move_to_front()
		return
	if p != null:
		p.remove_child(node)
	if new_parent != null:
		new_parent.add_child(node)


func _toggle(type, text, state):
	var b = _get_control(type, text)
	b.pressed = !state if b.base.get_changed() else state
	return b.pressed


func label(text):
	_get_control(GUILabel, text)


func button(text):
	return _get_control(GUIButton, text).base.get_changed()


func buttonpress(text):
	var b = _get_control(GUIButton, text)
	b.base.get_changed()
	return b.pressed


func toggle(text, state: bool):
	return _toggle(GUIToggle, text, state)


func checkbox(text, state: bool):
	return _toggle(GUICheckBox, text, state)


func checkbutton(text, state: bool):
	return _toggle(GUICheckButton, text, state)


func options(selected: int, options: Array):
	var b = _get_control(GUIOptions)
	b.set_options(options)
	if !b.base.get_changed():
		b.selected = selected
	return b.selected


func pickcolor(color: Color, edit_alpha: bool = true):
	var c = _get_control(GUIPickColor)
	c.edit_alpha = edit_alpha
	c.get_popup().rect_global_position = c.rect_global_position + Vector2(0, c.rect_size.y)
	if !c.base.get_changed():
		c.color = color
	return c.color


func progress(value: float, percent_visible: bool = true):
	var c = _get_control(GUIProgress)
	c.show_percentage = percent_visible
	c.min_value = 0
	c.max_value = 100
	c.value = value * 100


func spin(value, min_value, max_value, step = null):
	var c: Control = _get_control(GUISpin)
	c.min_value = min_value
	c.max_value = max_value
	c.step = (1.0 if value is int else 0.001) if step == null else step
	if !c.base.get_changed() && c.value != value:
		c.value = value
	return c.value


func line(text: String):
	var l = _get_control(GUILine)
	if !l.base.get_changed() && l.text != text:
		l.text = text
	return l.text


func _get_box(type):
	var box = _get_control(type)
	boxes.append(box)
	return box


func control():
	_get_box(GUIControl)
	return true


func hbox(separation = null):
	var box = _get_box(GUIHBox)
	box.set("custom_constants/separation", separation)
	return true


func vbox(separation = null):
	var box = _get_box(GUIVBox)
	box.set("custom_constants/separation", separation)
	return true


func grid(columns: int, vseparation = null, hseparation = null):
	var box = _get_box(GUIGrid)
	box.columns = columns
	box.set("custom_constants/vseparation", vseparation)
	box.set("custom_constants/hseparation", hseparation)
	return true


func panel():
	_get_box(GUIPanel)
	return true


func margin(left: int = 0, top: int = 0, right: int = 0, bottom: int = 0):
	var box = _get_box(GUIMargin)
	box.set("custom_constants/margin_left", left)
	box.set("custom_constants/margin_top", top)
	box.set("custom_constants/margin_right", right)
	box.set("custom_constants/margin_bottom", bottom)
	return true


func center():
	_get_box(GUICenter)
	return true


func scroll():
	_get_box(GUIScroll)
	return true


func end():
	boxes.pop_back()


func hslide(value, min_value, max_value, step = null):
	var c: Control = _get_control(GUIHSlide)
	c.min_value = min_value
	c.max_value = max_value
	c.step = (1.0 if value is int else 0.001) if step == null else step
	if !c.base.get_changed() && c.value != value:
		c.value = value
	return c.value
