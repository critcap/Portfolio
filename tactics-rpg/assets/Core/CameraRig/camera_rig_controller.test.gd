extends GdUnitTestSuite

var cr: CameraRigController

enum { FORWARD, BACK, LEFT, RIGHT }


func before():
	cr = auto_free(CameraRigController.new())
	cr.rotation_degrees.y = 45


func test_if_on_FORWARD_both_axis_have_the_same_length():
	var velocity = emulate_on_move(FORWARD, cr.transform)
	assert_float(velocity.x).is_equal(velocity.z)


func test_right_behavior():
	var velocity_f = get_1_dir_velocity(emulate_on_move(FORWARD, cr.transform))
	var velocity_b = get_1_dir_velocity(emulate_on_move(BACK, cr.transform))
	var velocity_l = get_1_dir_velocity(emulate_on_move(LEFT, cr.transform))
	var velocity_r = get_1_dir_velocity(emulate_on_move(RIGHT, cr.transform))
	assert_float(velocity_f.round().z).is_equal(-1.0)
	assert_float(velocity_b.round().z).is_equal(+1.0)
	assert_float(velocity_l.round().x).is_equal(-1.0)
	assert_float(velocity_r.round().x).is_equal(+1.0)


func get_1_dir_velocity(position: Vector3) -> Vector3:
	if abs(position.x) == abs(position.z):
		position = position.rotated(Vector3(0, 1, 0), -0.00001)
	var min_a = position.min_axis()
	var max_a = position.max_axis()
	var axis = max_a if position[max_a] > abs(position[min_a]) else min_a
	var output = Vector3.ZERO
	output[axis] = position[axis]
	return output


func emulate_on_move(dir, transform: Transform) -> Vector3:
	var velocity = Vector3.ZERO
	match dir:
		FORWARD:
			velocity -= transform.basis.z
		BACK:
			velocity += transform.basis.z
		LEFT:
			velocity -= transform.basis.x
		RIGHT:
			velocity += transform.basis.x
	return velocity.normalized()
