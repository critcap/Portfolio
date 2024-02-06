extends HBoxContainer

@export var Player: Node
@onready var bars: Array = Array()
# Called when the node enters the scene tree for the first time.
func _ready():
	if !Player:
		return
	
	for charge in range(0, Player.Charge):
		var bar: ProgressBar = ProgressBar.new()
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		add_child(bar)
		bars.append(bar)

	
	
func _process(delta):
	pass
