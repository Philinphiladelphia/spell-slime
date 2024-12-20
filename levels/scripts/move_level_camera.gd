extends Camera2D

# Exported variables for maximum x and y distances
@export var max_distance_x = 500.0
@export var max_distance_y = 300.0

# Deadzone sizes
@export var deadzone_size_x: float = 100.0
@export var deadzone_size_y: float = 100.0

var original_position : Vector2

@export var randomStrength: float = 50.0
@export var shakeFade: float = 10.0

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0


# i need sinusoidal two-directional smooth caerma shake for the main menu.
# this sahke is great for player feedback but too jittery for the main menu

func apply_shake(amount):
	shake_strength = amount
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength,shake_strength))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Get the mouse position relative to the viewport
	var mouse_position = get_local_mouse_position()

	# Calculate the offset from the tower position
	var target_position = original_position + mouse_position

	# Apply deadzone
	if abs(mouse_position.x - original_position.x -2000) < deadzone_size_x:
		target_position.x = original_position.x
	if abs(mouse_position.y - original_position.y -5000) < deadzone_size_y:
		target_position.y = original_position.y

	# Clamp the offset to the maximum distances
	target_position.x = clamp(target_position.x, original_position.x-max_distance_x, original_position.x+max_distance_x)
	target_position.y = clamp(target_position.y, original_position.y-max_distance_y, original_position.y+max_distance_y)

	# Move the camera towards the target position asymptotically
	global_position = lerp(global_position, target_position, 0.03)
	
	if Input.is_action_just_pressed("shake"):
		apply_shake(200)
		
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shakeFade * delta)
		
		offset = randomOffset()
