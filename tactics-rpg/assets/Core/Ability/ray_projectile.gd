class_name RayProjectile
extends Projectile


func simulate_projectile(tile: Tile, start: Vector3) -> TrajectoryData:
	var target_position := tile.translation
	target_position.y += 0.5 if tile.content != null else 0.0

	trajectory = TrajectoryData.new()
	trajectory.points.append(start)

	var ray = _rays[0]
	ray.global_transform.origin = start
	ray.cast_to = target_position - start
	ray.enabled = true
	
	yield(get_tree(), "physics_frame")	
	yield(get_tree(), "physics_frame")
	
	trajectory.collider = ray.get_collider()
	trajectory.points += [ray.get_collision_point()] if ray.is_colliding() else [target_position]

	return trajectory
