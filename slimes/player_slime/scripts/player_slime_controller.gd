class_name PlayerController
extends Node2D

@export var softbody: SoftBody2D
@export var decorations: Array[Node2D]

@onready var smp = $player_state

@export var movement_stats: MovementStats
@export var player_attack_stats: PlayerAttackStats
@export var spell: Spell

@export var cursor_radials : Node2D

@export var hurtbox: Area2D
@export var i_frame_time = 0.5

@export var can_jump: bool = true
@export var can_cast: bool = true

@export var max_health = 100
@export var health = 100

@export var damage_duration = 0.2

var mana: float = 0

var last_hit: int = 0

var jump_power: float
var time_since_last_jump: float = 0.0

var cast_power: float
var time_since_last_cast: float = 0.0
var casting: bool = false
@export var cast_radius: float = 30

var original_modulate: Color

var slime_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_modulate = softbody.modulate
	mana = player_attack_stats.max_mana
	jump_power = movement_stats.min_jump
	slime_position = softbody.get_bones_center_position()
	
	if cursor_radials:
		cursor_radials.set_rad_1_min_max(movement_stats.min_jump, movement_stats.max_jump_power)
		cursor_radials.set_rad_2_min_max(0, player_attack_stats.max_mana)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	time_since_last_jump += delta
	time_since_last_cast += delta
	
	slime_position = softbody.get_bones_center_position()
	
	# regen mana
	if not casting:
		mana = min(mana + player_attack_stats.mana_recharge_rate * delta, player_attack_stats.max_mana)
	
	if cursor_radials and time_since_last_jump < movement_stats.min_jump_interval:
		cursor_radials.set_rad_1_value(cursor_radials.radial_1.value - ((movement_stats.max_jump_power/movement_stats.min_jump_interval) * delta))
	
	if cursor_radials and time_since_last_cast < spell.fire_rate and not casting:
		cursor_radials.set_rad_2_value(cursor_radials.radial_2.value - ((player_attack_stats.max_mana/spell.fire_rate) * delta))
	
	if Time.get_ticks_msec() - last_hit < damage_duration*1000:
		softbody.modulate = Color(1, 0.5, 0.5, 1)
	else:
		softbody.modulate = original_modulate
	
	#process slime hits
	hurtbox.global_position = slime_position
	handle_hits()
	
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

func handle_hits():
	if hurtbox.has_overlapping_bodies():
		var body: RigidBody2D = hurtbox.get_overlapping_bodies()[0]
		var time:int = Time.get_ticks_msec()
		
		if (time - last_hit) < (i_frame_time*1000):
			return
			
		last_hit = time
		
		var random_int = randi() % 9 + 1
		SoundManager.play_sfx("slime_impact_" + str(random_int), 0, -6, 1)
		
		var damage_amount: int = body.get_parent().get_parent().damage
		
		var hit_marker: HitMarker = GunUtils.hit_marker_scene.instantiate()
		hit_marker.set_damage(damage_amount)
		hit_marker.global_position = slime_position + Vector2(0,-10)
		get_tree().root.add_child(hit_marker)
		
		health -= damage_amount

func jump(jump_direction: Vector2, jump_power: float) -> void:
	if can_jump:
		SoundManager.play_sfx("drop1", 0, -6, 1)
		softbody.apply_impulse(jump_direction * jump_power)


func _on_player_state_transited(from: Variant, to: Variant) -> void:
	if from == "jump_active" and to == "jump_inactive":
		freeze()
		
		
	if from == "jump_inactive" and to == "jump_active":
		unfreeze()

func handle_cast(delta:float):
	if time_since_last_cast < spell.fire_rate:
		return
		
	if Input.is_action_pressed("secondary_fire"):
		casting = true
		if mana <= 0:
			return
		
		cast_power = min(cast_power + (spell.per_second_mana_consumption * delta), player_attack_stats.max_mana)
		mana -= spell.per_second_mana_consumption * delta
		if cursor_radials:
			cursor_radials.set_rad_2_value(cast_power)
	elif Input.is_action_just_released("secondary_fire"):
		cast_spell(cast_power)
		
		casting = false
		cast_power = 0
		time_since_last_cast = 0.0
		
func cast_spell(cast_power:int):
	var cast_direction = (get_global_mouse_position() - slime_position).normalized()
	var cast_location = slime_position + (cast_direction) * cast_radius			
	
	GunUtils.fire_projectile(spell.projectile_type, cast_location, spell.damage, cast_direction.angle(), 2000, 5, 0.5, 5, 0.03)

func handle_jump(delta:float):
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

func freeze():
	var bodies = softbody.get_rigid_bodies()
	var centerish_body = bodies[len(bodies)/2].rigidbody
	centerish_body.freeze = true
	
func unfreeze():
	var bodies = softbody.get_rigid_bodies()
	var centerish_body = bodies[len(bodies)/2].rigidbody
	centerish_body.freeze = true

func _on_player_state_updated(state: Variant, delta: Variant) -> void:
	if DialogueController.active:
		cursor_radials.hide()
		return
	else:
		cursor_radials.show()
	
	match state:
		"jump_active":
			if can_jump:
				handle_jump(delta)
			
			if can_cast:
				handle_cast(delta)

		"jump_inactive":
			pass
