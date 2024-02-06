extends Camera2D
 
@export var character: CharacterBody2D
 
func _physics_process(delta):
	if character.velocity.x > 15 or character.velocity.y > 15 or -character.velocity.x > -15 or -character.velocity.y > -15:
		global_position = character.global_position.round()
		force_update_scroll()
