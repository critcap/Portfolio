class_name Directions

enum { SOUTH, EAST, NORTH, WEST }


static func dir_to_vec3(dir: int) -> Vector3:
	match dir:
		0:
			return Vector3.BACK
		1:
			return Vector3.RIGHT
		2:
			return Vector3.FORWARD
		3:
			return Vector3.LEFT

	return Vector3.ZERO

	
static func vec3_to_dir(vec3: Vector3) -> int:
	match vec3:
		Vector3.BACK:
			return 0
		Vector3.RIGHT:
			return 1
		Vector3.FORWARD:
			return 2
		Vector3.LEFT:
			return 3
	return 0
