class_name Turn
extends CommandHistory

var id: int
var subject: Node
var ability: Ability
var targets: = []
var sequence: TurnSequence

var command: Command setget , get_command


func get_command() -> Command:
	if self.index < 0:
		return null
	return get_children()[self.index]


func reset() -> void:
	while self.index >= 0:
		var _command = get_command()

		if !_command.can_undo():
			_command.free()

		undo()
