class_name SlimeTracker
extends Node

var collected_slime_positions: PackedVector2Array
var powder_activated_bitmap: PackedInt32Array

var slime_elements: PackedInt32Array
var slime_circle_sizes: PackedInt32Array

var slime_damages: PackedInt32Array

var current_max_slime_health: float = 0.0
var current_slime_health: float = 0.0

var max_health_seen: float = 0

var slime_goal_position: Vector2 = Vector2(0,0)

var spawns_done: bool = false

var ratio = 650.0/200.0

@export var managed_spawners: Array[Node2D]
@export var powderviewport: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	collected_slime_positions.clear()
	powder_activated_bitmap.clear()
	
	slime_elements.clear()
	slime_circle_sizes.clear()
	
	slime_damages.clear()
	
	current_slime_health = 0.0
	current_max_slime_health = 0.0
	
	var all_depleted: bool = true
	for slime_spawner in managed_spawners:
		collected_slime_positions.append_array(slime_spawner.slime_positions)
		powder_activated_bitmap.append_array(slime_spawner.powder_activated_bitmap)
		slime_elements.append_array(slime_spawner.slime_elements)
		slime_circle_sizes.append_array(slime_spawner.slime_circle_sizes)
		slime_damages.append_array(slime_spawner.slime_damages)
		
		current_slime_health += slime_spawner.current_slime_health
		current_max_slime_health += slime_spawner.current_max_slime_health
		
		all_depleted = all_depleted and slime_spawner.spawner_depleted
		
	if all_depleted:
		spawns_done = true
		
	if current_max_slime_health > max_health_seen:
		max_health_seen = current_max_slime_health
		
	for i in range(len(collected_slime_positions)):
		if powder_activated_bitmap[i] != 1:
			continue
		
		var position: Vector2 = collected_slime_positions[i]
		var slime_circle_size: int = slime_circle_sizes[i]
		var element: int = slime_elements[i]
		
		powderviewport.circle(position, slime_circle_size, element)

func enable_slime_lights() -> void:
	for slime_spawner in managed_spawners:
		slime_spawner.enable_light = true

func set_slime_goal_position(value: Vector2) -> void:
	slime_goal_position = value
	for slime_spawner in managed_spawners:
		slime_spawner.set_slime_goal_position(value)
	

func _on_body_entered(body: Node2D) -> void:
	pass
