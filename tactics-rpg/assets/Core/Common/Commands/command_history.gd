class_name CommandHistory
extends Node

var _undos: int = 0

var index: int setget , get_index
var stack: Array setget , get_stack


func get_index() -> int:
	return get_children().size() - (_undos + 1)


func get_stack() -> Array:
	return get_children()


#  Adds new Command to the stack. Clears all commands above the current index
func add_command(cmd: Command) -> void:	
	# removes all currently undone commands when adding a new one
	if _undos > 0:
		for child in _undos:
			get_children()[-1].free()
		_undos = 0
		
	# check if current command was perfomed, in case it was not replaces it
	if get_children().size() > 0 && !get_children()[self.index].can_undo():
		get_children()[self.index].free()

	add_child(cmd)


#  calls undo on command at index except when the root command was already called.
#  If undo is called on the root command _is_at_bottom will be set to true.
func undo() -> void:
	if self.index < 0:
		return

	if !self.stack[self.index].can_undo():
		return
	
	get_children()[self.index].undo()
	_undos += 1


#  calls execute on command at index + 1 with shortcut set to true
func redo() -> void:
	if _undos < 1:
		return
	if self.index + 1 >= get_children().size():
		return
	
	# calls execute with true, for faster redo process
	get_children()[self.index].execute(true)
	_undos -= 1
