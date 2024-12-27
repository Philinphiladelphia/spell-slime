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

var stats: Dictionary = {}

@export var base_stats_file_path: String = "res://savedata/tower_stats/stats.json"
@export var temp_stats_file_path: String = "res://savedata/tower_stats/temp_stats.json"

func _ready() -> void:
	StatsManager.clear_temp_stats()
	StatsManager.load_temp_stats()
	
	for item in GlobalInventory.get_items():
		StatsManager.apply_item_effects(item)
		StatsManager.display_item_properties(item)
		
	load_base_stats()
	load_temp_stats()
	apply_combined_stats()
	tower_light.energy = light_energy

func load_base_stats() -> void:
	var file: FileAccess = FileAccess.open(base_stats_file_path, FileAccess.READ)
	if file:
		var json: JSON = JSON.new()
		var file_text: String = file.get_as_text()
		json.parse(file_text)
		stats = json.data
		file.close()
	else:
		print("Base stats file not found: " + base_stats_file_path)
	print("base tower stats loaded: " + base_stats_file_path)

func load_temp_stats() -> void:
	# Combine base stats with temp stats
	var temp_stats = StatsManager.temp_stats
	for key in temp_stats.keys():
		print("temp stats: " + key + ": " + str(temp_stats[key]))
		if stats.has(key):
			stats[key] += temp_stats[key]
			print("combined stats: " + key + ": " + str(stats[key]))
		else:
			stats[key] = temp_stats[key]
			
	print("temp tower stats added")

func save_base_stats() -> void:
	var file: FileAccess = FileAccess.open(base_stats_file_path, FileAccess.WRITE)
	if file:
		var json_string: String = JSON.stringify(stats, "\t")
		file.store_string(json_string)
		file.close()

func delete_temp_stats_file() -> void:
	if FileAccess.file_exists(temp_stats_file_path):
		DirAccess.remove_absolute(temp_stats_file_path)

func apply_combined_stats() -> void:
		tower_max_health = stats.max_health
		tower_health = tower_max_health
		
		$spell_machine_tower/main_gun.max_rotation_speed = stats.max_rotation_speed
		$spell_machine_tower/main_gun.primary_projectile_dmg = stats.primary_projectile_dmg
		$spell_machine_tower/main_gun.primary_firing_velocity = stats.primary_firing_velocity
		$spell_machine_tower/main_gun.primary_max_lifespan = stats.primary_max_lifespan
		$spell_machine_tower/main_gun.primary_mass = stats.primary_mass
		$spell_machine_tower/main_gun.primary_post_hit_lifespan = stats.primary_post_hit_lifespan
		$spell_machine_tower/main_gun.primary_firing_interval = stats.primary_firing_interval
		$spell_machine_tower/main_gun.primary_shake = max(stats.primary_shake, 0)
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

func add_item_to_queue(item):
	ItemQueue.append(item)
	StatsManager.apply_item_effects(item)

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
	machine_gun_cooldown_bar._set_health($spell_machine_tower/main_gun.primary_projectiles_fired)

	if $spell_machine_tower/main_gun.secondary_firing:
		harpoon_cooldown_bar._set_health($spell_machine_tower/main_gun.secondary_firing_interval * 100)

	harpoon_cooldown_bar._set_health(($spell_machine_tower/main_gun.secondary_firing_interval - $spell_machine_tower/main_gun.secondary_firing_timer) * 100)

func _on_damage_timer_timeout() -> void:
	$spell_machine_tower.modulate = Color(1, 1, 1)  # Reset the color to white

func _on_hurt_box_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if spellward_health <= 0:
		apply_tower_damage(body.get_parent().get_parent().damage)
