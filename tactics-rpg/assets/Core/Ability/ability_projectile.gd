class_name Projectile
extends Node

export(float) var resolution: float = 1.0
export(float) var _max_vertical: float = 0.7

var trajectory: TrajectoryData

var _rays: Array


func _ready() -> void:
	for _i in range(0, int(max(resolution - 1, 1.0))):
		var ray = RayCast.new()
		_rays.append(ray)
		add_child(ray)


func simulate_projectile(tile: Tile, start: Vector3) -> TrajectoryData:
	return trajectory


class TrajectoryData:
	extends Node
	var points: Array = []
	var collider: Node

	var collision_point: Vector3 setget , get_collision_point

	func get_collision_point() -> Vector3:
		if points.empty():
			return Vector3.ZERO
		return points[-1]
