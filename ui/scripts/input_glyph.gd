extends Node2D

@export var input: InputEventAction

var displayed_key: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var actions = InputMap.action_get_events(input.action)
	var keycode = DisplayServer.keyboard_get_keycode_from_physical(actions[0].physical_keycode)
	displayed_key = OS.get_keycode_string(keycode)
	$Label.text = displayed_key


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
