extends Node

var collected_slime_positions: PackedVector2Array
var powder_activated_bitmap: PackedInt32Array

var slime_elements: PackedInt32Array
var slime_circle_sizes: PackedInt32Array

var slime_damages: PackedInt32Array

var current_max_slime_health = 0
var current_slime_health = 0

var tower_midpoint = Vector2(0,0)

var spawns_done = false

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
	
	current_slime_health = 0
	current_max_slime_health = 0
	
	var all_depleted = true
	for slime_spawner in get_children():
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

func enable_slime_lights():
	for slime_spawner in get_children():
		slime_spawner.enable_light = true

func set_tower_midpoint(value):
	tower_midpoint = value
	for slime_spawner in get_children():
		slime_spawner.set_tower_midpoint(value)
	

func _on_body_entered(body: Node2D) -> void:
	pass
