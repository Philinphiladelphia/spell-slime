extends Area2D

# Reference to the main script that handles powder manifestation
@export var powder_toy_script: Node

func _ready():
	# Ensure the powder_toy_script is set
	assert(powder_toy_script != null)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = event.position
		# Scale mouse position to the coordinate system used by manifest_powder_circle_wrapper
		var x = int(mouse_pos.x * powder_toy_script.x_resolution / get_viewport().size.x)
		var y = int(mouse_pos.y * powder_toy_script.y_resolution / get_viewport().size.y)
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Left click
			powder_toy_script.powder_manifestation_buffer.append({"x": x, "y": y, "type": 10, "size": 17})
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			# Right click - do something different
			powder_toy_script.powder_manifestation_buffer.append({"x": x, "y": y, "type": 10, "size": 87}) # Example: different type and size
