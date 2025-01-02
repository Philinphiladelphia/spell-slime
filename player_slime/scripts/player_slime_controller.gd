extends Node2D

@export var softbody: SoftBody2D

@export var max_jump_power: float = 100.0
@export var charge_rate: float = 60.0
@export var min_jump: float = 60.0
@export var min_jump_interval: float = 0.5  # Minimum time interval between jumps in seconds

var jump_power: float = min_jump
var time_since_last_jump: float = 0.0

var slime_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slime_position = softbody.get_bones_center_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_last_jump += delta
	slime_position = softbody.get_bones_center_position()
	
	var rigidbody = softbody.get_rigid_bodies()[0].rigidbody
	var angle_difference = wrapf(-rigidbody.rotation, -PI, PI)
	softbody.constant_torque = angle_difference * 100  # Adjust the multiplier as needed

	if Input.is_action_pressed("primary_fire"):
		jump_power = min(jump_power + charge_rate * delta, max_jump_power)
	elif Input.is_action_just_released("primary_fire"):
		if time_since_last_jump >= min_jump_interval:
			var mouse_position = get_global_mouse_position()
			var jump_direction = (mouse_position - slime_position).normalized()
			jump(jump_direction, jump_power)
			jump_power = min_jump
			time_since_last_jump = 0.0  # Reset time since last jump

func jump(jump_direction: Vector2, jump_power: float) -> void:
	SoundManager.play_sfx("drop1", 0, -6, 1)
	softbody.apply_impulse(jump_direction * jump_power)
