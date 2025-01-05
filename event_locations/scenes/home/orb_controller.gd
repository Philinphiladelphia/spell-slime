extends AnimatedSprite2D

# Exported variable to enable or disable the light
@export var active: bool = true

# Reference to the PointLight2D node
var light: PointLight2D
var original_texture_scale: float
var random_offset: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	light = $PointLight2D
	light.visible = active
	light.energy = 0.0
	original_texture_scale = light.texture_scale
	random_offset = randf() * 2.0 * PI  # Random offset between 0 and 2*PI

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		# Create a glowing effect by oscillating the light's energy
		light.energy = 1.0 + sin(Time.get_ticks_msec() / 1000.0 + random_offset) * 0.5
		# Oscillate the light's texture_scale within 50% of its original value
		light.texture_scale = original_texture_scale * (0.75 + sin(Time.get_ticks_msec() / 1000.0 + random_offset) * 0.25)
	else:
		light.energy = 0.0
		light.texture_scale = original_texture_scale
