class_name Command
extends Node


var _performed: bool = false setget, can_undo


func can_undo() -> bool:
	return _performed
	

#  executes the command. shortcut param can be passed when called.
#  This allows a faster execution when needed e.g. when you redo a command.
func execute(_shortcut := false) -> void:
	if _performed:
		return
	_performed = true


func undo() -> void:
	if !_performed:
		return	
	_performed = false
