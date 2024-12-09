extends Node2D

var spellward_health_margin = 200
var spellward_max_health = 0
var spellward_health = spellward_max_health
var tower_max_health = 10000
var tower_health = tower_max_health
var health_offset = Vector2(-100, -1300)

var is_dead = false

@onready var spellward_health_bar = $CanvasLayer/SpellwardHealthBar
@onready var tower_health_bar = $CanvasLayer/TowerHealthBar
@onready var machine_gun_cooldown_bar = $CanvasLayer/MachineGunCooldown
@onready var harpoon_cooldown_bar = $CanvasLayer/HarpoonCooldown

var base_stats = {
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
		"secondary_projectile_dmg": 30,
		"secondary_firing_velocity": 10000,
		"secondary_max_lifespan": 2,
		"secondary_post_hit_lifespan": 0.4,
		"secondary_mass": 10,
		"secondary_firing_interval": 3
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
	spellward_health = amount

func init_tower_health(max_health):
	tower_health_bar.init_health(max_health)

func apply_tower_damage(amount):
	tower_health_bar._set_health(tower_health_bar.health - amount)
	tower_health = tower_health_bar.health - amount
	$spell_machine_tower.modulate = Color(1, 0.2, 0.2)  # Set the color to red
	$damage_timer.start()

func _process(delta: float) -> void:
	if tower_health <= 0:
		hide()
		is_dead = true
		#process_mode = PROCESS_MODE_DISABLED
	
	
	machine_gun_cooldown_bar._set_health($spell_machine_tower/main_gun.primary_projectiles_fired)
	
	var harpoon_value = 0
	if $spell_machine_tower/main_gun.secondary_firing:
		harpoon_cooldown_bar._set_health($spell_machine_tower/main_gun.secondary_firing_interval * 100)
	
	harpoon_cooldown_bar._set_health(($spell_machine_tower/main_gun.secondary_firing_interval - $spell_machine_tower/main_gun.secondary_firing_timer) * 100)

func _on_damage_timer_timeout() -> void:
	$spell_machine_tower.modulate = Color(1, 1, 1)  # Reset the color to white


func _on_hurt_box_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if spellward_health <= 0:
		apply_tower_damage(body.get_parent().get_parent().damage)
