extends AnimatedSprite2D

signal portal_entered

@export var player: PlayerController

var suck_slime: bool = false
@export var activated: bool = true
var attract_force: float = 3000

@export var attract_distance: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not activated:
		return
	
	var dist: float = PlayerState.player_location.distance_to(global_position)
	
	if suck_slime or dist < attract_distance:
		var attract_direction: Vector2 = (global_position - PlayerState.player_location).normalized()
		player.softbody.apply_force(attract_direction * attract_force) 
	
	if activated:
		if $Area2D.has_overlapping_bodies():
			player.freeze()
			await get_tree().create_timer(3.0).timeout
			portal_entered.emit()
