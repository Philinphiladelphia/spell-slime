extends PathFollow2D

@export var snake_head: RigidBody2D

var move: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if move:
		set_progress(get_progress() + 100 * delta)

		snake_head.global_position = global_position
		snake_head.rotation = rotation
