class_name WalkMovement
extends Movement

var animation_speed: float


func extended_search(from: Tile, to: Tile) -> bool:
	if abs(from.position.y - to.position.y) > jump:
		return false

	if to.content:
		return false
	
	var to_terrain = to.terrain
	var water = Terrain.WATER
	
	if to.terrain == Terrain.WATER:
		return false

	return .extended_search(from, to)


func can_traverse_water() -> bool:
	return false


func traverse(tile: Tile) -> void:
	var targets: Array = []
	while tile != null:
		if tile.translation == unit.translation:
			break
		targets.append(tile)
		tile = tile.previous
	targets.invert()
	for t in targets:
		yield(get_tree(), "idle_frame")
		turn(t)
		var tweener = Tween.new()
		add_child(tweener)
		if t.translation.y != unit.translation.y:
			yield(step(t, tweener), "completed")
		elif (unit.translation - t.translation).length() > 1:
			yield(jump(t, tweener), "completed")
		else:
			yield(walk(t, tweener), "completed")
		tweener.queue_free()
		unit.place(t)
	emit_signal("traverse_finished")


# private coroutines
func walk(to: Tile, tween: Tween) -> void:
	tween.interpolate_property(
		unit, "translation", unit.translation, to.translation, animation_speed, Tween.TRANS_LINEAR
	)
	tween.start()
	yield(tween, "tween_completed")


func step(to: Tile, tween: Tween) -> void:
	var pos = unit.translation
	var diff = to.translation - unit.translation
	var pos1 = pos + Vector3(diff.x, 0, diff.z) * 0.25
	var pos2 = pos1 + Vector3(diff.x, 0, diff.z) * 0.25 + Vector3(0, diff.y, 0)
	var pos3 = pos2 + Vector3(diff.x, 0, diff.z) * 0.5
	tween.interpolate_property(
		unit, "translation", unit.translation, pos1, animation_speed * 0.25, Tween.TRANS_LINEAR, 0
	)
	tween.interpolate_property(
		unit,
		"translation",
		pos1,
		pos2,
		animation_speed * 0.25,
		Tween.TRANS_LINEAR,
		0,
		animation_speed * 0.25
	)
	tween.interpolate_property(
		unit,
		"translation",
		pos2,
		pos3,
		animation_speed * 0.5,
		Tween.TRANS_LINEAR,
		0,
		animation_speed * 0.5
	)
	tween.start()
	yield(tween, "tween_all_completed")
	
	
func jump(to: Tile, tween: Tween) -> void:
	var jump_speed = animation_speed * 1.4
	var height = 0.5
	tween.interpolate_property(
		unit, "translation", unit.translation, to.translation, jump_speed, Tween.TRANS_LINEAR
	)
	tween.interpolate_property(
		unit, "translation:y", unit.translation.y, unit.translation.y + height, jump_speed * 0.5, Tween.TRANS_CUBIC
	)
	tween.interpolate_property(
		unit, "translation:y", unit.translation.y + height, to.translation.y, jump_speed* 0.5, Tween.TRANS_CUBIC, 0,
		jump_speed * 0.5
	)
	tween.start()
	yield(tween, "tween_all_completed")
