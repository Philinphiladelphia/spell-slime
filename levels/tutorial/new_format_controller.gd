extends Node2D

@export var player: Node2D
@export var slime_tracker: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	slime_tracker.set_slime_goal_position(player.slime_position)
