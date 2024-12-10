extends Node2D

var level_camera: Camera2D

var camera_move_speed = 1000

var health = 100
var init_spellward_health = true

# slimes should jump over the tower, dropping powder. Another reason for flying slimes.

var powder_scale = 23
var powder_offset_x = 0
var powder_offset_y = 95

var total_slime_health = 10

var tower_health = 1000


## Defines the path to the game scene. Hides the play button if empty.
@export_file("*.tscn") var game_scene_path : String
@export var options_packed_scene : PackedScene
@export var credits_packed_scene : PackedScene

var options_scene
var credits_scene
var sub_menu

func load_scene(scene_path : String):
	SceneLoader.load_scene(scene_path)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_camera = $level_camera
	
	var tower_element = 17
	
	$PowderViewport.powder_instance.health_element = tower_element
	
	$PowderViewport.powder_instance.polygon(Vector2(60,60), 20.0, 8, 5, tower_element)
	$PowderViewport.powder_instance.powder_toy.powder_box(40, 120, 80, 75, tower_element)
	
	
	$slime_tracker.set_tower_midpoint($SpellMachineTower.global_position.x)
	
	$PowderViewport.powder_instance.powder_toy.flood_powder(60, 60, 28, 0) # diamond
	
	$SpellMachineTower.init_tower_health(tower_health)
	
	$slime_health_layer/HealthBar.init_health(100)
	$slime_health_layer/HealthBar._set_health(0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $SpellMachineTower.is_dead == true:
		queue_free()
	
	# init powder health. Gotta wait a sec for the initial powder manifests to go off
	var powder_health = $PowderViewport.powder_instance.get_health()
	if (powder_health > $SpellMachineTower.spellward_health_margin) && init_spellward_health:
		$SpellMachineTower.init_spellward_health(powder_health - $SpellMachineTower.spellward_health_margin)
		init_spellward_health = false
		
	# smoking barrel
	
	$SpellMachineTower.set_spellward_health(powder_health - $SpellMachineTower.spellward_health_margin)
	
	total_slime_health = max(total_slime_health, float($slime_tracker.current_max_slime_health))
	
	$slime_health_layer/HealthBar._set_health(100*($slime_tracker.current_slime_health/total_slime_health))
	
	# set and get total slime health
	
	# handle slime positions
	var slime_positions = $slime_tracker.collected_slime_positions
	var slime_powder_activation = $slime_tracker.powder_activated_bitmap
	
	for i in range(len(slime_positions)):
		
		if slime_powder_activation[i] != 1:
			continue
		
		var element = $slime_tracker.slime_elements[i]
		var slime_circle_size = $slime_tracker.slime_circle_sizes[i]
		
		var dist = slime_positions[i] - $SpellMachineTower.position
		
		# I might need to make powdertoy an autoload singleton.
		
		if $SpellMachineTower.tower_health <= 0:
			#$PowderViewport.queue_free() this segfaults
			print("powder toy freed")
		
		if dist.x < 1000 && dist.y < 1000:
			var powder_x = 120-(60-(dist.x/powder_scale)) + powder_offset_x
			var powder_y = (dist.y/powder_scale) + powder_offset_y
			#powder_toy.clear_sim_area(wall_offset, wall_offset, width - (wall_offset*2), border)
			#$PowderViewport.powder_instance.powder_toy.clear_sim_area(powder_x, powder_y, slime_circle_size, slime_circle_size)
			$PowderViewport.powder_instance.circle(Vector2(powder_x,powder_y), slime_circle_size, element)
	
	if Input.is_physical_key_pressed(KEY_A):
		level_camera.position.x -= camera_move_speed * delta
	elif Input.is_physical_key_pressed(KEY_D):
		level_camera.position.x += camera_move_speed * delta
	elif Input.is_physical_key_pressed(KEY_E):
		$PowderViewport.powder_instance.polygon(Vector2(60,60), 30.0, 8, 2, 2)

	# Determine the camera's relative position to the center and call face_left or face_right
	var camera_center_x = level_camera.position.x
	var screen_center_x = $SpellMachineTower.position.x

	if camera_center_x > screen_center_x:
		$SpellMachineTower.face_left()
	else:
		$SpellMachineTower.face_right()



# I need to make slimes damage the tower's main health
