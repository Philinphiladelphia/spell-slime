extends RigidBody2D

# Scenes
var basic_projectile_scene : PackedScene
var missile_projectile_scene : PackedScene
var slime_scene : PackedScene

# Rotation parameters
var rotation_offset : float = 4.75
var max_rotation_speed : float = 0.03

# Primary gun parameters
var primary_projectile_dmg = 1
var primary_firing_velocity = 500
var primary_max_lifespan = 1
var primary_mass = 1
var primary_firing = false
var primary_firing_timer = 0.0
var primary_firing_interval = 0.05
var primary_post_hit_lifespan = 0.1
var primary_shake = 0.1

# Secondary gun parameters
var secondary_projectile_dmg = 1
var secondary_firing_velocity = 2000
var secondary_max_lifespan = 1
var secondary_mass = 1
var secondary_firing = false
var secondary_firing_timer = 0.0
var secondary_firing_interval = 1.5
var secondary_post_hit_lifespan = 0.5
var secondary_shake = 0

# used to align firing location with the barrel
var barrel_length = 350

# Cooldown parameters
var primary_projectiles_fired = 0
var primary_cooldown_max = 20
var primary_cooldown_rate = 5.0 # 5 projectiles per second

func _ready() -> void:
	# Load the projectile and slime scenes
	basic_projectile_scene = preload("res://upgrade_tree/scenes/basic_projectile.tscn")
	missile_projectile_scene = preload("res://upgrade_tree/scenes/harpoon_projectile.tscn")
	slime_scene = preload("res://slimes/scenes/small_slime.tscn")

func _process(delta: float) -> void:
	# Handle rotation
	handle_rotation()
	
	primary_firing_timer -= delta
	
	if primary_projectiles_fired > 0 && primary_projectiles_fired < primary_cooldown_max:
		primary_projectiles_fired -= delta * primary_cooldown_rate

	# Handle primary firing
	if primary_firing and primary_projectiles_fired < primary_cooldown_max:
		if primary_firing_timer <= 0:
			fire_projectile(basic_projectile_scene, primary_projectile_dmg, primary_firing_velocity, primary_max_lifespan, primary_post_hit_lifespan, primary_mass, primary_shake)
			primary_firing_timer = primary_firing_interval
			primary_projectiles_fired += 1
			if primary_projectiles_fired >= primary_cooldown_max:
				var timer = Timer.new()
				timer.wait_time = 4
				timer.one_shot = true
				add_child(timer)
				timer.connect("timeout", reset_primary_cooldown)
				timer.start()

	secondary_firing_timer -= delta
	# Handle secondary firing
	if secondary_firing:
		if secondary_firing_timer <= 0:
			fire_projectile(missile_projectile_scene, secondary_projectile_dmg, secondary_firing_velocity, secondary_max_lifespan, secondary_post_hit_lifespan, secondary_mass, secondary_shake)
			secondary_firing_timer = secondary_firing_interval

func reset_primary_cooldown():
	primary_projectiles_fired = 0

func handle_rotation() -> void:
	var mouse_position = get_global_mouse_position()
	var target_angle = (mouse_position - global_position).angle() + rotation_offset
	var angle_difference = wrapf(target_angle - rotation, -PI, PI)

	if abs(angle_difference) > max_rotation_speed:
		if angle_difference < 0:
			rotation -= max_rotation_speed
		else:
			rotation += max_rotation_speed
	else:
		rotation = target_angle

func fire_projectile(projectile_scene, damage: int, velocity: float, max_lifespan: float, post_hit_lifespan: float, mass: float, gun_shake : float) -> void:
	var node_to_fire = projectile_scene.instantiate()
	apply_firing_velocity(node_to_fire, velocity, gun_shake)
	node_to_fire.damage = damage
	node_to_fire.max_projectile_lifespan = max_lifespan
	node_to_fire.projectile_mass = mass
	node_to_fire.post_hit_lifespan = post_hit_lifespan
	
	$Node/ProjectileSpawnPoint.add_child(node_to_fire)
	var projectile_location_vector = Vector2.DOWN.rotated(rotation)
	node_to_fire.position = get_parent().get_parent().global_position + projectile_location_vector * barrel_length
	node_to_fire.rotation = rotation

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			primary_firing = event.pressed
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			secondary_firing = event.pressed

func apply_firing_velocity(node, velocity, shake):
	var random_addition = (((randi() % 100) - 50) / 100.0) * shake
	var local_move_direction = Vector2(0, 1).rotated(get_global_transform().get_rotation() + random_addition)
	node.apply_impulse(local_move_direction * velocity)
