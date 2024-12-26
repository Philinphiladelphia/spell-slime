extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	#minimized
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	
	#maximized
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED) 
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 
