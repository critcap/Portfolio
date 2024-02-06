class_name EventSystem
extends Node

signal sequence_complete
signal sequence_ended

var root_event: GameEvent
var root_sequence: GDScriptFunctionState
var open_reactions: Array

# * public methods
func is_active() -> bool: return root_sequence != null


func perform(event: GameEvent) -> void:
	if is_active():
		return
	
	root_event = event
	root_sequence = Sequence(event)

func add_reaction(event: GameEvent) -> void:
	if open_reactions != null: 
		open_reactions.append(event)
	
func _process(_delta) -> void:
	if root_sequence == null:
		return
	if !root_sequence.is_valid():
		root_sequence = null
		root_sequence = null
		open_reactions = []
		emit_signal("sequence_complete")

# * private coroutines

func Sequence(event: GameEvent):
	var phase = MainPhase(event.prepare)
	if phase is GDScriptFunctionState:
		yield(phase, "completed")

	phase = MainPhase(event.perform)
	if phase is GDScriptFunctionState:
		yield(phase, "completed")

	if root_event == event:
		phase = EventPhase("check_for_death", event)
	emit_signal("sequence_ended", event)

func MainPhase(phase: Phase):
	#var is_action_cancelled = phase.event.is_cancelled
	open_reactions = []

	var process = phase.Process()
	if process is GDScriptFunctionState:
		yield(process, "completed")

	var reactions = open_reactions

	process = ReactPhase(reactions)
	if process is GDScriptFunctionState:
		yield(process, "completed")

		
func ReactPhase(reactions: Array):
	reactions.sort_custom(self, "_sort_reactions")
	reactions.invert()
	for event in reactions:
		var sub_process = Sequence(event)
		if sub_process is GDScriptFunctionState:
			yield(sub_process, "completed")

func EventPhase(_signal: String, event: GameEvent) -> void:
	open_reactions = []
	GlobalSignals.emit_signal(_signal, event)
	var reactions = open_reactions
	var process = ReactPhase(reactions)
	if process is GDScriptFunctionState:
		yield(process, "completed")

static func _sort_reactions(a,b):
	if a.priority < b.priority:
		return true
	return false	 
