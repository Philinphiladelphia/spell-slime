extends Sprite2D

var original_texture_scale: float
var random_offset: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_offset = randf() * 2.0 * PI
	original_texture_scale = $PointLight2D.texture_scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var random_value: float = sin(Time.get_ticks_msec() / 1000.0 + random_offset) * 0.5
	
	position = position + Vector2(0, -random_value/7.0)
	
	# Create a glowing effect by oscillating the light's energy
	$PointLight2D.energy = 1.0 + random_value
	# Oscillate the light's texture_scale within 50% of its original value
	$PointLight2D.texture_scale = original_texture_scale * (0.75 + sin(Time.get_ticks_msec() / 1000.0 + random_offset) * 0.25)
