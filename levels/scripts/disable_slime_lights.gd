extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_node("slime_tracker").enable_slime_lights()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
