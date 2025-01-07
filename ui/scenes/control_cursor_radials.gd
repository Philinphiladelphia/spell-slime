extends Node2D

@export var radial_1: TextureProgressBar
@export var radial_2: TextureProgressBar

var rad_1_max = 100.0
var rad_2_max = 100.0

var rad_1_value = 50.0
var rad_2_value = 50.0

func set_rad_1_min_max(min:float, max: float):
	radial_1.min_value = min
	radial_1.max_value = max
	
func set_rad_2_min_max(min:float, max: float):
	radial_2.min_value = min
	radial_2.max_value = max
	
func set_rad_1_value(v: float):
	radial_1.value = v
	
func set_rad_2_value(v: float):
	radial_2.value = v

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	global_position = mouse_position
	
	if is_visible_in_tree():
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
