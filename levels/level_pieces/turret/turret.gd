extends Sprite2D

@export var max_rotation_speed: float = 0.03

@export var is_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func handle_rotation() -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	var target_angle: float = (mouse_position - global_position).angle()
	var angle_difference: float = wrapf(target_angle - rotation, -PI, PI)

	if abs(angle_difference) > max_rotation_speed:
		if angle_difference < 0:
			rotation -= max_rotation_speed
		else:
			rotation += max_rotation_speed
	else:
		rotation = target_angle
