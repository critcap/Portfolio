class_name ProjectileAnimation
extends AbilityAnimation


export (PackedScene) var projectile_prefab
export (float, 0.1, 20.0) var projectile_speed: = 1.0
export (float, 0.1, 20.0) var lingering_duration: = 5.0 


func play() -> void:
	var prefab = projectile_prefab.instance()
	add_child(prefab)
	prefab.visible = false
	var trajectory = owner.get_node("Projectile").trajectory
	setup_prefab(prefab, trajectory)	
	
	yield(self.shoot_projectile(prefab, trajectory), "completed")
	yield(get_tree().create_timer(lingering_duration, false), "timeout")
	prefab.queue_free()


func setup_prefab(_prefab: Spatial, trajectory: Projectile.TrajectoryData) -> void:
	#rotate projectile to target
	var start = trajectory.points[0]
	var end = trajectory.points[-1]
	_prefab.global_transform.origin = start
	_prefab.look_at(end, Vector3.UP)
	_prefab.rotation_degrees.y -= 90


func shoot_projectile(_prefab: Spatial, trajectory: Projectile.TrajectoryData) -> void:
	var tween = Tween.new()
	add_child(tween)
	
	var remaining_points = trajectory.points.slice(1, -1)
	_prefab.visible = true
	for p in remaining_points:
		var translation = p - _prefab.global_transform.origin
		var duration: float = translation.length() / 10.0
		tween.interpolate_method(_prefab, "look_at_x", _prefab.global_transform.origin, p, duration)
		tween.interpolate_property(_prefab, "translation", _prefab.translation, _prefab.translation + translation, duration)
		tween.start()
		yield(tween, "tween_all_completed")
	emit_signal("animation_finished")		
