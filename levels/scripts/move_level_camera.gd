extends Camera2D

# Exported variables for maximum x and y distances
@export var max_distance_x = 500.0
@export var max_distance_y = 300.0

# Deadzone size
@export var deadzone_size: float = 100.0

var original_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Get the mouse position relative to the viewport
	var mouse_position = get_local_mouse_position()
	
	# Calculate the offset from the tower position
	var target_position = original_position + mouse_position
	
	# Apply deadzone
	if abs(mouse_position.x) < deadzone_size:
		target_position.x = original_position.x
	if abs(mouse_position.y) < deadzone_size:
		target_position.y = original_position.y
	
	## Clamp the offset to the maximum distances
	target_position.x = clamp(target_position.x, original_position.x-max_distance_x, original_position.x+max_distance_x)
	target_position.y = clamp(target_position.y, original_position.y-max_distance_y, original_position.y+max_distance_y)
	
	# Move the camera towards the target position asymptotically
	global_position = lerp(global_position, target_position, 0.03)
