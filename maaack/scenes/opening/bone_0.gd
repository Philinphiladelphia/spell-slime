extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_modulate(lerp(get_modulate(), Color(1,1,1,1), delta))
	
	var angle_difference = rotation
	var impulse_strength = 30

	if angle_difference > 0:
		apply_central_impulse(Vector2(-impulse_strength, 0))
	else:
		apply_central_impulse(Vector2(impulse_strength, 0))
	
