extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("primary_fire"):
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - $slime_controller/slime_node/slime_soft_body.get_bones_center_position()).normalized()
		var force = direction * 10 # Adjust the force magnitude as needed
		
		$slime_controller/slime_node/slime_soft_body.apply_impulse(force)
