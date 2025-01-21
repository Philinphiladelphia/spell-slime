extends Node2D

@export var player: PlayerController
@export var slime_tracker: SlimeTracker
@export var spawner: Spawner
@export var level_boundary: StaticBody2D
@export var level_ui: LevelUIController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_boundary.process_mode = Node.PROCESS_MODE_DISABLED
	level_boundary.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	slime_tracker.set_slime_goal_position(PlayerState.player_location)

func _on_spawner_1_depleted() -> void:
	level_boundary.process_mode = Node.PROCESS_MODE_DISABLED
	level_boundary.hide()

func _on_spawner_1_active() -> void:
	level_boundary.process_mode = Node.PROCESS_MODE_ALWAYS
	level_boundary.show()


func _on_player_collider_body_entered(body: Node2D) -> void:
	PowderController.summon_powder_toy($powder_toy_location.global_position)
	level_ui.init_level_ui(slime_tracker)
