extends Node2D

var spellward_health_margin = 200 # you still die if there are only 20 particles
var spellward_max_health = 0

var spellward_health = spellward_max_health

var tower_max_health = 10000
var tower_health = tower_max_health
# I need to define something similar to a powder hitbox. If powder enters that region, it deals damage to the tower.
# I'll also need to maintain a seperate json damage map for each powder type. Some types may even be 0 damage or negative damage (heal the tower).
# powder of different types deal damage for each second within the defined powder hitbox zone. The damage is added up every frame.

# for now, if a slime touches the tower, the tower will take damage.

# Called when the node enters the scene tree for the first time.

# I might wanna reconsider vertical gravity for the final game.

# I can shoot small projectiles like flak and have powder spawn on them when they expire. That's how my spells work.

var health_offset = Vector2(-100,-1300)

@onready var spellward_health_bar = $CanvasLayer/SpellwardHealthBar
@onready var tower_health_bar = $CanvasLayer/TowerHealthBar
@onready var machine_gun_cooldown_bar = $CanvasLayer/MachineGunCooldown
@onready var harpoon_cooldown_bar = $CanvasLayer/HarpoonCooldown

# the tower has magical defenses as shields and when they're gone, it takes damage directly from the slimes.
# like spirit hearts and red hearts.


# this script should really be on one node down
func _ready() -> void:
	$spell_machine_tower/main_gun.max_rotation_speed = 0.08
	
	$spell_machine_tower/main_gun.primary_projectile_dmg = 10
	$spell_machine_tower/main_gun.primary_firing_velocity = 6000
	$spell_machine_tower/main_gun.primary_max_lifespan = 1
	$spell_machine_tower/main_gun.primary_mass = 4
	$spell_machine_tower/main_gun.primary_post_hit_lifespan = 0.05
	$spell_machine_tower/main_gun.primary_firing_interval = 0.15
	$spell_machine_tower/main_gun.primary_shake = 0.2
	
	$spell_machine_tower/main_gun.primary_cooldown_max = 8
	$spell_machine_tower/main_gun.primary_cooldown_rate = 3
	
	machine_gun_cooldown_bar.init_health($spell_machine_tower/main_gun.primary_cooldown_max)
	
	$spell_machine_tower/main_gun.secondary_projectile_dmg = 30
	$spell_machine_tower/main_gun.secondary_firing_velocity = 10000
	$spell_machine_tower/main_gun.secondary_max_lifespan = 2
	$spell_machine_tower/main_gun.secondary_post_hit_lifespan = 0.4
	$spell_machine_tower/main_gun.secondary_mass = 10
	$spell_machine_tower/main_gun.secondary_firing_interval = 3
	# primary gun
	
	harpoon_cooldown_bar.init_health($spell_machine_tower/main_gun.secondary_firing_interval * 100)
	#harpoon_cooldown_bar.get_child(0).hide()

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
	#print("applied_damage" + str(amount))
	#print("tower health: "+ str(tower_health))
	tower_health_bar._set_health(tower_health_bar.health - amount)
	tower_health = tower_health_bar.health - amount

func _process(delta: float) -> void:
	machine_gun_cooldown_bar._set_health($spell_machine_tower/main_gun.primary_projectiles_fired)
	
	var harpoon_value = 0
	if $spell_machine_tower/main_gun.secondary_firing:
		harpoon_cooldown_bar._set_health($spell_machine_tower/main_gun.secondary_firing_interval * 100)
	
	harpoon_cooldown_bar._set_health(($spell_machine_tower/main_gun.secondary_firing_interval - $spell_machine_tower/main_gun.secondary_firing_timer) * 100)
	
	if (spellward_health <= spellward_health_margin):
		pass
