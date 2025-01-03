extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_global_rect().has_point(get_global_mouse_position()):
		MouseGlobal.set_mouse_owned(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		MouseGlobal.set_mouse_owned(false)
