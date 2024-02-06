class_name Phase


var event #: GameEvent cannot type this because of an parser error
var handler: FuncRef
var viewer: FuncRef

# * public methods

func _init(_event, _handler):
	event = _event
	handler = _handler


# * coroutines

func Process():
	var hit_key_frame = false
	if viewer != null: 
		hit_key_frame = yield(viewer.call_func(event, handler), "completed")
	if !hit_key_frame:
		handler.call_func()
