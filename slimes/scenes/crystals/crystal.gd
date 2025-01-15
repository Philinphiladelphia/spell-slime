class_name Crystal
extends RigidBody2D

@export var attract_distance: int = 200
@export var attract_force: float = 5000.0

@export var value: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $player_area.has_overlapping_bodies():
		PlayerState.crystals += value
		SoundManager.play_sfx("crystal_pickup")
		queue_free()

	
	var dist: float = PlayerState.player_location.distance_to(global_position)
	var pos = global_position
	
	if dist < attract_distance:
		var attract_direction: Vector2 = (PlayerState.player_location - global_position).normalized()
		apply_force(attract_direction * attract_force) 
