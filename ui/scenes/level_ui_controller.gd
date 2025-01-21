class_name LevelUIController
extends CanvasLayer

@export var hp_bar: HealthBar
@export var ammo_bar: HealthBar
@export var mana_bar: HealthBar
@export var enemy_hp_bar: HealthBar

@export var enemy_hp_hidden: bool = false

@export var _slime_tracker: SlimeTracker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ammo_bar.set_bar(0)
	
	PlayerState.initialized.connect(init_player_bars)
	
	GunUtils.turret_activated.connect(show_ammo)
	GunUtils.turret_deactivated.connect(hide_ammo)
	
	if enemy_hp_hidden:
		%enemy_hp_container.hide()
		
	%crystal_number.text = str(PlayerState.crystals)
	
func hide_ammo():	
	%ammo_container.hide()
	
func show_ammo():	
	%ammo_container.show()

func init_player_bars():
	hp_bar.init_bar(PlayerState.max_health)
	mana_bar.init_bar(PlayerState.max_mana)
	

func init_level_ui(slime_tracker: SlimeTracker):
	_slime_tracker = slime_tracker

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hp_bar.set_bar(PlayerState.health)
	mana_bar.set_bar(PlayerState.mana)
	
	%crystal_number.text = str(PlayerState.crystals)
	
	# hide enemy hp if it's 0
	if enemy_hp_bar.bar_value <= 0:
		%enemy_hp_container.hide()
	elif enemy_hp_bar.bar_value > 0:
		%enemy_hp_container.show()
	
	if not (_slime_tracker):
		return
	
	enemy_hp_bar.max_value = _slime_tracker.max_health_seen
	enemy_hp_bar.set_bar(_slime_tracker.current_slime_health)
	
	
	if GunUtils.active_turret:
		ammo_bar.max_value = GunUtils.active_turret.firing_strategy.ammo
		ammo_bar.set_bar(GunUtils.active_turret.ammo)
	else:
		ammo_bar.set_bar(0)
