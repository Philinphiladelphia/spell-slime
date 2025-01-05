extends Node2D

@export var softbody: SoftBody2D
@export var decorations: Array[Node2D]

@export var max_jump_power: float = 100.0
@export var charge_rate: float = 60.0
@export var min_jump: float = 60.0
@export var min_jump_interval: float = 0.5  # Minimum time interval between jumps in seconds

@export var cursor_radials : Node2D

@export var upright_force: int = 200

var jump_power: float = min_jump
var time_since_last_jump: float = 0.0

var slime_position: Vector2

@export var is_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slime_position = softbody.get_bones_center_position()
	
	if cursor_radials:
		cursor_radials.set_rad_1_min_max(min_jump, max_jump_power)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	time_since_last_jump += delta
	slime_position = softbody.get_bones_center_position()
	
	var rigidbody = softbody.get_rigid_bodies()[0].rigidbody
	var angle_difference = wrapf(-rigidbody.rotation, -PI, PI)
	softbody.constant_torque = angle_difference * upright_force  # Adjust the multiplier as needed
	
	if len(decorations) > 0:
		for decoration in decorations:
			decoration.global_position = slime_position
			decoration.rotation = rigidbody.rotation
	
	if not is_active:
		return

	if time_since_last_jump >= min_jump_interval:
		if Input.is_action_pressed("primary_fire"):
			jump_power = min(jump_power + charge_rate * delta, max_jump_power)
			
			if cursor_radials:
				cursor_radials.set_rad_1_value(jump_power)
			return
		elif Input.is_action_just_released("primary_fire"):
			var mouse_position = get_global_mouse_position()
			var jump_direction = (mouse_position - slime_position).normalized()
			jump(jump_direction, jump_power)
			jump_power = min_jump
			time_since_last_jump = 0.0  # Reset time since last jump
			return
				
	if cursor_radials:
		cursor_radials.set_rad_1_value(cursor_radials.radial_1.value - ((max_jump_power/min_jump_interval) * delta))

func jump(jump_direction: Vector2, jump_power: float) -> void:
	SoundManager.play_sfx("drop1", 0, -6, 1)
	softbody.apply_impulse(jump_direction * jump_power)
