extends Camera2D

@export var slime_to_follow: Node2D

@export var move_x: bool = true
@export var move_y: bool = true

@export var x_offset: int = 0
@export var y_offset: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_x:
		global_position.x = lerp(global_position.x, slime_to_follow.slime_position.x + x_offset, delta*2)
	if move_y:
		global_position.y = lerp(global_position.y, slime_to_follow.slime_position.y + y_offset, delta*2)
