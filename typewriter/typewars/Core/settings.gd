class_name Settings
extends Resource

# Test Arguments
export(int) var args_base_size: int = 60
export(int) var args_base_mode: int = 1

# Test Factory Constants
export(int) var factory_min_size: int = 3
export(int) var factory_max_size: int = 8

# Colors
# input label color
export(Color) var correct_input_color: Color = Color.green
export(Color) var false_input_color: Color = Color.red

# input queue color

export(Color) var first_in_queue_color: Color = Color(0.5, 0.5, 0.5, 1)
export(Color) var second_in_queue_color: Color = Color(0.5, 0.5, 0.5, 0.5)
