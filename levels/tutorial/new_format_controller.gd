extends Node2D

@export var player: PlayerController
@export var slime_tracker: SlimeTracker
@export var spawner: Spawner
@export var level_ui: LevelUIController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawner.start_spawns()
	
	level_ui.hp_bar.init_bar(player.max_health)
	level_ui.mana_bar.init_bar(player.player_attack_stats.max_mana)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	slime_tracker.set_slime_goal_position(player.slime_position)
	
	level_ui.hp_bar.set_bar(player.health)
	level_ui.mana_bar.set_bar(player.mana)
	
	level_ui.enemy_hp_bar.max_value = slime_tracker.max_health_seen
	level_ui.enemy_hp_bar.set_bar(slime_tracker.current_slime_health)
	
	if GunUtils.active_turret:
		level_ui.ammo_bar.set_bar(GunUtils.active_turret.ammo)
	else:
		level_ui.ammo_bar.set_bar(0)


func _on_turret_activated(turret: Turret) -> void:
	level_ui.ammo_bar.init_bar(GunUtils.active_turret.firing_strategy.ammo)
