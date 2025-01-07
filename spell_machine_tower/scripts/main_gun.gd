extends RigidBody2D

# Scenes
var basic_projectile_scene : PackedScene
var missile_projectile_scene : PackedScene
var slime_scene : PackedScene

# Rotation parameters
var rotation_offset : float = 4.75
var max_rotation_speed : float = 0.03

# Primary gun parameters
var primary_projectile_dmg: float = 1
var primary_firing_velocity: float = 500
var primary_max_lifespan: float = 1
var primary_mass: float = 1
var primary_firing: bool = false
var primary_firing_timer: float = 0.0
var primary_firing_interval: float = 0.05
var primary_post_hit_lifespan: float = 0.1
var primary_shake: float = 0.1

var cooldown_timer : Timer
var is_smoking: bool = false

# Secondary gun parameters
var secondary_projectile_dmg: float = 1
var secondary_firing_velocity: float = 2000
var secondary_max_lifespan: float = 1
var secondary_mass: float = 1
var secondary_firing: bool = false
var secondary_firing_timer: float = 0.0
var secondary_firing_interval: float = 1.5
var secondary_post_hit_lifespan: float = 0.5
var secondary_shake: float = 0

# used to align firing location with the barrel
var barrel_length: int = 500

# Cooldown parameters
var primary_projectiles_fired: float = 0.0
var primary_cooldown_max: float = 20.0
var primary_cooldown_rate: float = 5.0 # 5 projectiles per second

var lightning_animation: PackedScene
var basic_animation: PackedScene

@export var level_camera: Camera2D

# gem system
# slimes scan for particle damage, json dict to determine how much

func _ready() -> void:
	# Load the projectile and slime scenes
	basic_projectile_scene = preload("res://upgrade_tree/scenes/basic_projectile.tscn")
	missile_projectile_scene = preload("res://upgrade_tree/scenes/harpoon_projectile.tscn")
	slime_scene = preload("res://slimes/scenes/small_slime.tscn")
	
	basic_animation = preload("res://upgrade_tree/scenes/on_hit_animation.tscn")
	lightning_animation = preload("res://upgrade_tree/assets/sprite_animations/lightning_animation.tscn")
	
	
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = 4
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	cooldown_timer.connect("timeout", reset_primary_cooldown)

func _process(delta: float) -> void:
	# Handle rotation
	handle_rotation()
	
	primary_firing_timer -= delta
	
	if primary_projectiles_fired > 0 && primary_projectiles_fired < primary_cooldown_max:
		primary_projectiles_fired -= delta * primary_cooldown_rate

	# Handle primary firing
	if primary_firing and primary_projectiles_fired < primary_cooldown_max:
		if primary_firing_timer <= 0:
			if not SoundManager.is_playing("machine_gun_fire"):
				SoundManager.play_sfx("machine_gun_fire", 0, -20, 1)
				#SoundManager.play_sfx("machine_gun_fire", 0, 0.6, 1)
			fire_projectile(basic_projectile_scene, primary_projectile_dmg, primary_firing_velocity, primary_max_lifespan, primary_post_hit_lifespan, primary_mass, primary_shake)
			primary_firing_timer = primary_firing_interval
			primary_projectiles_fired += 1.0
			if primary_projectiles_fired >= primary_cooldown_max:
				is_smoking = true
				cooldown_timer.start()
	else:
		SoundManager.stop("machine_gun_fire")
		
	secondary_firing_timer -= delta
	# Handle secondary firing
	if secondary_firing:
		if secondary_firing_timer <= 0:
			SoundManager.play_sfx("harpoon", 0, -12, 3)
			level_camera.apply_shake(50)
			fire_projectile(missile_projectile_scene, secondary_projectile_dmg, secondary_firing_velocity, secondary_max_lifespan, secondary_post_hit_lifespan, secondary_mass, secondary_shake)
			secondary_firing_timer = secondary_firing_interval

func reset_primary_cooldown() -> void:
	is_smoking = false
	primary_projectiles_fired = 0

func handle_rotation() -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	var target_angle: float = (mouse_position - global_position).angle() + rotation_offset
	var angle_difference: float = wrapf(target_angle - rotation, -PI, PI)

	if abs(angle_difference) > max_rotation_speed:
		if angle_difference < 0:
			rotation -= max_rotation_speed
		else:
			rotation += max_rotation_speed
	else:
		rotation = target_angle

func fire_projectile(projectile_scene: PackedScene, damage: int, velocity: float, max_lifespan: float, post_hit_lifespan: float, mass: float, gun_shake : float) -> void:
	var node_to_fire: Node = projectile_scene.instantiate()
	apply_firing_velocity(node_to_fire, velocity, gun_shake)
	node_to_fire.damage = damage
	node_to_fire.max_projectile_lifespan = max_lifespan
	node_to_fire.projectile_mass = mass
	node_to_fire.post_hit_lifespan = post_hit_lifespan
	
	$Node/ProjectileSpawnPoint.add_child(node_to_fire)
	var projectile_location_vector: Vector2 = Vector2.DOWN.rotated(rotation)
	node_to_fire.position = get_parent().get_parent().global_position + projectile_location_vector * barrel_length
	node_to_fire.rotation = rotation

func _physics_process(delta: float) -> void:
	primary_firing = false
	secondary_firing = false
	
	if Input.is_action_pressed("primary_fire"):
		primary_firing = true
	elif Input.is_action_pressed("secondary_fire"):
		secondary_firing = true

func apply_firing_velocity(node: Node, velocity: float, shake: float) -> void:
	var random_addition: float = (((randi() % 100) - 50) / 100.0) * shake
	var local_move_direction: Vector2 = Vector2(0, 1).rotated(get_global_transform().get_rotation() + random_addition)
	node.apply_impulse(local_move_direction * velocity)
