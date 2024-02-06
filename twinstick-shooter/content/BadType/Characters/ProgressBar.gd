extends ProgressBar

@export var Player: Node
# Called when the node enters the scene tree for the first time.
func _ready():
	if Player:
		max_value = Player.Charge * 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = Player.Charge * 100
