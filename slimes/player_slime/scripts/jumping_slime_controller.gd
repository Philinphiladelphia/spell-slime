class_name JumpingSlime
extends Node2D

@export var softbody: SoftBody2D
@export var decorations: Array[Node2D]

@export var direction: Vector2 = Vector2(1,1)
@export var jump_interval: float = 2.0

@export var jump_power: float = 20.0

@export var upright_force: int = 100

var time_since_last_jump: float = 0.0

@export var is_active: bool = false

var soft_body_scene: PackedScene = preload("res://slimes/player_slime/scenes/slime_soft_body.tscn")

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
	softbody.constant_torque = angle_difference * upright_force  # Adjust the multiplier as needed

	if len(decorations) > 0:
		for decoration in decorations:
			decoration.global_position = slime_position
			decoration.rotation = rigidbody.rotation

	if not is_active:
		return

	if time_since_last_jump >= jump_interval:
		jump(direction, jump_power)
		time_since_last_jump = 0.0

func freeze():
	var bodies = softbody.get_rigid_bodies()
	var centerish_body = bodies[len(bodies)/2].rigidbody
	centerish_body.freeze = true
	
func unfreeze():
	var bodies = softbody.get_rigid_bodies()
	var centerish_body = bodies[len(bodies)/2].rigidbody
	centerish_body.freeze = false
	
func reset():
	var new_body: SoftBody2D = soft_body_scene.instantiate()
	softbody.queue_free()
	add_child(new_body)
	move_child(new_body, 0)
	var dash_direction = (get_global_mouse_position() - slime_position).normalized()
	softbody = new_body
	

func jump(jump_direction: Vector2, jump_power: float) -> void:
	SoundManager.play_sfx("drop1", 0, -6, 0.5)
	softbody.apply_impulse(jump_direction * jump_power)
