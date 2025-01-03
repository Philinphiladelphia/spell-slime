extends Node

var mouse_owned : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_mouse_owned(value: bool):
	mouse_owned = value
	
func get_mouse_owned():
	return mouse_owned

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
