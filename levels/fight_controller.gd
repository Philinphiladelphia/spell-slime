extends Node

@export var player: PlayerController
@export var slime_tracker: SlimeTracker
@export var spawner: Spawner
@export var level_ui: LevelUIController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	slime_tracker.set_slime_goal_position(player.slime_position)
	level_ui.init_level_ui(slime_tracker)
