extends Node2D

# spellward is particulate based, so all ints
var spellward_health_margin: int = 200
var spellward_max_health: int = 0
var spellward_health: int = spellward_max_health


var tower_max_health: float = 10000
var tower_health: float = tower_max_health
var health_offset: Vector2 = Vector2(-100, -1300)

var is_dead: bool = false

@export var tower_light: PointLight2D
@export var light_energy = 0.6

@onready var spellward_health_bar: Node = $CanvasLayer/SpellwardHealthBar
@onready var tower_health_bar: Node = $CanvasLayer/TowerHealthBar
@onready var machine_gun_cooldown_bar: Node = $CanvasLayer/MachineGunCooldown
@onready var harpoon_cooldown_bar: Node = $CanvasLayer/HarpoonCooldown

@onready var level_camera: Node = get_parent().camera_node

var base_stats: Dictionary = {
	"slime1": {
		"max_health": 10000,
		"primary_projectile_dmg": 10,
		"primary_firing_velocity": 6000,
		"primary_max_lifespan": 1,
		"primary_mass": 4,
		"primary_post_hit_lifespan": 0.05,
		"primary_firing_interval": 0.15,
		"primary_shake": 0.2,
		"primary_cooldown_max": 8,
		"primary_cooldown_rate": 3,
		"secondary_projectile_dmg": 10,
		"secondary_firing_velocity": 15000,
		"secondary_max_lifespan": 2,
		"secondary_post_hit_lifespan": 0.4,
		"secondary_mass": 5,
		"secondary_firing_interval": 1.5
	},
		"slime2": {
		"max_health": 10000,
		"primary_projectile_dmg": 100,
		"primary_firing_velocity": 6000,
		"primary_max_lifespan": 1,
		"primary_mass": 4,
		"primary_post_hit_lifespan": 0.05,
		"primary_firing_interval": 0.5,
		"primary_shake": 0.0,
		"primary_cooldown_max": 4,
		"primary_cooldown_rate": 1,
		"secondary_projectile_dmg": 30,
		"secondary_firing_velocity": 10000,
		"secondary_max_lifespan": 2,
		"secondary_post_hit_lifespan": 0.4,
		"secondary_mass": 10,
		"secondary_firing_interval": 3
	},
	# Add more slimes as needed
}

func _ready() -> void:
	set_base_stats("slime1")
	
	tower_light.energy = light_energy

func set_base_stats(slime_type: String) -> void:
	var stats = base_stats.get(slime_type, null)
	if stats:
		tower_max_health = stats.max_health
		tower_health = tower_max_health
		
		$spell_machine_tower/main_gun.max_rotation_speed = 0.08
		$spell_machine_tower/main_gun.primary_projectile_dmg = stats.primary_projectile_dmg
		$spell_machine_tower/main_gun.primary_firing_velocity = stats.primary_firing_velocity
		$spell_machine_tower/main_gun.primary_max_lifespan = stats.primary_max_lifespan
		$spell_machine_tower/main_gun.primary_mass = stats.primary_mass
		$spell_machine_tower/main_gun.primary_post_hit_lifespan = stats.primary_post_hit_lifespan
		$spell_machine_tower/main_gun.primary_firing_interval = stats.primary_firing_interval
		$spell_machine_tower/main_gun.primary_shake = stats.primary_shake
		$spell_machine_tower/main_gun.primary_cooldown_max = stats.primary_cooldown_max
		$spell_machine_tower/main_gun.primary_cooldown_rate = stats.primary_cooldown_rate
		
		$spell_machine_tower/main_gun.secondary_projectile_dmg = stats.secondary_projectile_dmg
		$spell_machine_tower/main_gun.secondary_firing_velocity = stats.secondary_firing_velocity
		$spell_machine_tower/main_gun.secondary_max_lifespan = stats.secondary_max_lifespan
		$spell_machine_tower/main_gun.secondary_post_hit_lifespan = stats.secondary_post_hit_lifespan
		$spell_machine_tower/main_gun.secondary_mass = stats.secondary_mass
		$spell_machine_tower/main_gun.secondary_firing_interval = stats.secondary_firing_interval
		
		machine_gun_cooldown_bar.init_health(stats.primary_cooldown_max)
		harpoon_cooldown_bar.init_health(stats.secondary_firing_interval * 100)

func apply_item_effects(item):
	if item.type == "health_boost":
		tower_max_health += item.value
		tower_health = tower_max_health
	elif item.type == "damage_boost":
		$spell_machine_tower/main_gun.primary_projectile_dmg += item.value

func add_item_to_queue(item):
	ItemQueue.append(item)
	apply_item_effects(item)

func face_left():
	$Slime.flip_h = true
	$stars2/PinJoint2D.motor_target_velocity = 0.2

func face_right():
	$Slime.flip_h = false
	$stars2/PinJoint2D.motor_target_velocity = -0.2

func init_spellward_health(amount):
	spellward_health_bar.init_health(amount)
	spellward_max_health = amount
	spellward_health = amount

func set_spellward_health(amount):
	spellward_health_bar._set_health(amount)
	
	if amount < spellward_health:
		if not SoundManager.is_playing("explosion2"):
			SoundManager.play_sfx("explosion2", 0, 1, 1)
	
	spellward_health = amount

func init_tower_health(max_health):
	tower_health_bar.init_health(max_health)

func apply_tower_damage(amount: float) -> void:
	level_camera.apply_shake(amount*10)
	if not SoundManager.is_playing("metal1"):
		SoundManager.play_sfx("metal1", 0, 2, pow(amount,0.3))
	
	tower_health_bar._set_health(tower_health_bar.health - amount)
	tower_health = tower_health_bar.health - amount
	$spell_machine_tower.modulate = Color(1, 0.2, 0.2)  # Set the color to red
	$damage_timer.start()

func _process(delta: float) -> void:
		#process_mode = PROCESS_MODE_DISABLED
		
	#if $spell_machine_tower/main_gun.primary_firing && not $spell_machine_tower/main_gun.is_smoking:
		#level_camera.apply_shake($spell_machine_tower/main_gun.primary_projectile_dmg)
	#
	
	machine_gun_cooldown_bar._set_health($spell_machine_tower/main_gun.primary_projectiles_fired)

	if $spell_machine_tower/main_gun.secondary_firing:
		harpoon_cooldown_bar._set_health($spell_machine_tower/main_gun.secondary_firing_interval * 100)
	
	harpoon_cooldown_bar._set_health(($spell_machine_tower/main_gun.secondary_firing_interval - $spell_machine_tower/main_gun.secondary_firing_timer) * 100)

func _on_damage_timer_timeout() -> void:
	$spell_machine_tower.modulate = Color(1, 1, 1)  # Reset the color to white


func _on_hurt_box_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if spellward_health <= 0:
		apply_tower_damage(body.get_parent().get_parent().damage)
