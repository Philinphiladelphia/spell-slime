class_name LevelUIController
extends CanvasLayer

@export var hp_bar: HealthBar
@export var ammo_bar: HealthBar
@export var mana_bar: HealthBar
@export var enemy_hp_bar: HealthBar

var _slime_tracker: SlimeTracker
var _player: PlayerController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ammo_bar.set_bar(0)
	
func init_level_ui(slime_tracker: SlimeTracker, player: PlayerController):
	hp_bar.init_bar(player.max_health)
	mana_bar.init_bar(player.player_attack_stats.max_mana)
	
	_slime_tracker = slime_tracker
	_player = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not (_slime_tracker and _player):
		return
	
	hp_bar.set_bar(_player.health)
	mana_bar.set_bar(_player.mana)
	
	enemy_hp_bar.max_value = _slime_tracker.max_health_seen
	enemy_hp_bar.set_bar(_slime_tracker.current_slime_health)
	
	
	if GunUtils.active_turret:
		ammo_bar.max_value = GunUtils.active_turret.firing_strategy.ammo
		ammo_bar.set_bar(GunUtils.active_turret.ammo)
	else:
		ammo_bar.set_bar(0)
