extends Camera2D

@export var slime_to_follow: Node2D

@export var move_x: bool = true
@export var move_y: bool = true

@export var x_offset: int = 0
@export var y_offset: int = 0

@export var x_move_speed: float = 2
@export var y_move_speed: float = 2

@export var shakeFade: float = 2.0
var shake_strength: float = 0.0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerState.active_cam = self

func apply_shake(amount):
	shake_strength = amount
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength,shake_strength))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_x:
		global_position.x = lerp(global_position.x, slime_to_follow.slime_position.x + x_offset, delta*x_move_speed)
	if move_y:
		global_position.y = lerp(global_position.y, slime_to_follow.slime_position.y + y_offset, delta*y_move_speed)
		
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shakeFade * delta)
		
		offset = randomOffset()
