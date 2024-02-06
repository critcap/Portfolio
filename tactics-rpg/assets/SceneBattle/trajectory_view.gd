class_name TrajectoryRenderer
extends LineRenderer

onready var collision_mark = $MeshInstance


func draw_trajectory(tile: Tile, data: Projectile.TrajectoryData) -> void:
	points = data.points
	collision_mark.global_transform.origin = data.collision_point
	collision_mark.visible = !is_collider_target(tile, data.collider)
	#visible = true
	

func is_collider_target(tile: Tile, collider: Node) -> bool:
	if !tile.content || !collider:
		return false
	
	if !(collider.owner is Actor):
		return false
	
	return tile.content == collider.owner
