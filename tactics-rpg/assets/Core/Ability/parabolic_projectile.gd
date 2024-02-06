class_name ParabolicProjectile
extends Projectile


func simulate_projectile(tile: Tile, start: Vector3) -> TrajectoryData:
	var target_position := tile.translation
	target_position.y += 0.5 if tile.content != null else 0.0

	var vertex := calculate_vertex(target_position, start)
	target_position.y = clamp(
		target_position.y,
		0.0,
		quadratic_bezier(start, vertex, start + Vector3(3, 0, 0), _max_vertical).y
	)

	trajectory = yield(
		self.calculate_projectile_trajectory(start, vertex, target_position), "completed"
	)
	return trajectory


func calculate_vertex(target: Vector3, start: Vector3) -> Vector3:
	var r = owner.ability_range
	var zenith = target - (target - start) / 2
	var difference = (target - start).abs()
	difference = difference[difference.max_axis()]
	difference = clamp(difference - r.min_horizontal, 0, 99)
	var scale := float(r.min_horizontal) / float(r.horizontal)
	zenith.y = start.y + (r.horizontal - (difference) * scale)
	return zenith


func calculate_projectile_trajectory(start: Vector3, vertex: Vector3, end: Vector3) -> TrajectoryData:
	var _trajectory = TrajectoryData.new()
	var _points = []
	for i in range(1, int(resolution) + 1, 1):
		var t = float(i) / resolution
		var point = quadratic_bezier(start, vertex, end, t)
		_points.append(point)
	#REVIEW can be move in the first for loop for more perfomance
	for p in _points:
		var index = _points.find(p)
		if (index + 1) >= _points.size():
			break
		var ray = _rays[index]
		ray.global_transform.origin = p
		ray.cast_to = _points[index + 1] - ray.global_transform.origin
		ray.enabled = true

	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")

	_trajectory.points.append(start)
	_trajectory.points.append(_rays[0].global_transform.origin)

	for r in _rays:
		if !r.is_colliding():
			_trajectory.points.append(r.global_transform.origin + r.cast_to)
			r.enabled = false
			continue

		_trajectory.points.append(r.get_collision_point())
		_trajectory.collider = r.get_collider()

		for ar in _rays.slice(_rays.find(r), -1):
			ar.enabled = false
		break

	return _trajectory


static func quadratic_bezier(p0: Vector3, p1: Vector3, p2: Vector3, t) -> Vector3:
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	return q0.linear_interpolate(q1, t)
