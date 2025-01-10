extends Node2D

@export var softbody: SoftBody2D
@export var decorations: Array[Node2D]

@onready var smp = $player_state

@export var movement_stats: MovementStats

@export var cursor_radials : Node2D

@export var hurtbox: Area2D

var jump_power: float
var time_since_last_jump: float = 0.0

var slime_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jump_power = movement_stats.min_jump
	slime_position = softbody.get_bones_center_position()
	
	if cursor_radials:
		cursor_radials.set_rad_1_min_max(movement_stats.min_jump, movement_stats.max_jump_power)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	time_since_last_jump += delta
	slime_position = softbody.get_bones_center_position()
	
	hurtbox.global_position = slime_position
	
	var rigidbody = softbody.get_rigid_bodies()[0].rigidbody
	var angle_difference = wrapf(-rigidbody.rotation, -PI, PI)
	softbody.constant_torque = angle_difference * movement_stats.upright_force  # Adjust the multiplier as needed
	
	if len(decorations) > 0:
		for decoration in decorations:
			decoration.global_position = slime_position
			decoration.rotation = rigidbody.rotation
			
	if GunUtils.active_turret:
		smp.set_trigger("deactivate")
	else:
		smp.set_trigger("activate")

func jump(jump_direction: Vector2, jump_power: float) -> void:
	SoundManager.play_sfx("drop1", 0, -6, 1)
	softbody.apply_impulse(jump_direction * jump_power)


func _on_player_state_transited(from: Variant, to: Variant) -> void:
	pass # Replace with function body.


func _on_player_state_updated(state: Variant, delta: Variant) -> void:
	match state:
		"jump_active":
			if time_since_last_jump < movement_stats.min_jump_interval:
				return
				
			if Input.is_action_pressed("primary_fire"):
				jump_power = min(jump_power + movement_stats.charge_rate * delta, movement_stats.max_jump_power)
				
				if cursor_radials:
					cursor_radials.set_rad_1_value(jump_power)
				return
			elif Input.is_action_just_released("primary_fire"):
				var mouse_position = get_global_mouse_position()
				var jump_direction = (mouse_position - slime_position).normalized()
				jump(jump_direction, jump_power)
				jump_power = movement_stats.min_jump
				time_since_last_jump = 0.0  # Reset time since last jump
				return
			else:
				if cursor_radials:
					cursor_radials.set_rad_1_value(cursor_radials.radial_1.value - ((movement_stats.max_jump_power/movement_stats.min_jump_interval) * delta))
				
		"jump_inactive":
			pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	var hit_marker: HitMarker = GunUtils.hit_marker_scene.instantiate()
	hit_marker.set_damage(area.get_parent().damage)
	hit_marker.global_position = slime_position
	
