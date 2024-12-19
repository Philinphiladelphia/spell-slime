extends Node2D

var level_camera: Camera2D

var camera_move_speed: int = 2500

var health: float = 100
var init_spellward_health: bool = true

# slimes should jump over the tower, dropping powder. Another reason for flying slimes.

var powder_scale: float = 23
var powder_offset_x: int = 0
var powder_offset_y: int = 95

var total_slime_health: float = 10

var tower_health: int = 1000


## Defines the path to the game scene. Hides the play button if empty.
@export_file("*.tscn") var game_scene_path : String
@export var options_packed_scene : PackedScene
@export var credits_packed_scene : PackedScene

@export var spelltowernode : Node2D

@export var camera_node : Camera2D

@onready var level_win_screen: PackedScene = preload("res://addons/maaacks_game_template/extras/scenes/overlaid_menus/level_won_menu.tscn")

var options_scene: PackedScene
var credits_scene: PackedScene
var sub_menu: PackedScene

var won: bool = false
var lost: bool = false

func load_scene(scene_path : String) -> void:
	SceneLoader.load_scene(scene_path)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_camera = $level_camera
	
	var tower_element: int = 67
	
	$PowderViewport.powder_instance.health_element = tower_element
	
	$PowderViewport.powder_instance.polygon(Vector2(60,60), 20.0, 8, 5, tower_element)
	$PowderViewport.powder_instance.powder_toy.powder_box(40, 120, 80, 75, tower_element)
	
	
	$slime_tracker.set_tower_midpoint($SpellMachineTower.global_position.x)
	
	$PowderViewport.powder_instance.powder_toy.flood_powder(60, 60, 28, 0) # diamond
	
	$SpellMachineTower.init_tower_health(tower_health)
	
	$slime_health_layer/HealthBar.init_health(100.0)
	$slime_health_layer/HealthBar._set_health(0.0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $SpellMachineTower.is_dead == true:
		SceneLoader.load_scene("res://maaack/scenes/menus/main_menu/main_menu_with_animations.tscn")
	
	# init powder health. Gotta wait a sec for the initial powder manifests to go off
	var powder_health: float = $PowderViewport.powder_instance.get_health()
	if (powder_health > $SpellMachineTower.spellward_health_margin) && init_spellward_health:
		$SpellMachineTower.init_spellward_health(powder_health - $SpellMachineTower.spellward_health_margin)
		init_spellward_health = false
		
	# smoking barrel
	
	$SpellMachineTower.set_spellward_health(powder_health - $SpellMachineTower.spellward_health_margin)
	
	total_slime_health = max(total_slime_health, float($slime_tracker.current_max_slime_health))
	
	$slime_health_layer/HealthBar._set_health(100*($slime_tracker.current_slime_health/total_slime_health))
	
	# set and get total slime health
	
	# handle slime positions
	var slime_positions: PackedVector2Array = $slime_tracker.collected_slime_positions
	var slime_powder_activation: PackedInt32Array = $slime_tracker.powder_activated_bitmap
	var slime_elements: PackedInt32Array = $slime_tracker.slime_elements
	var slime_circle_sizes: PackedInt32Array = $slime_tracker.slime_circle_sizes
	var ignore_elements: PackedInt32Array = []  # Add any elements to ignore here
	
	# player wins!
	if slime_positions.size() == 0 and $slime_tracker.spawns_done && not won:
		won = true
		var win: Node = level_win_screen.instantiate()
		#rewards.global_position = camera_node.global_position
		$slime_health_layer.add_child(win)
		#SceneLoader.load_scene("res://maaack/scenes/menus/main_menu/main_menu_with_animations.tscn")

	for i in range(len(slime_positions)):
		
		if slime_powder_activation[i] != 1:
			continue
		
		var element: int = $slime_tracker.slime_elements[i]
		var slime_circle_size: int = $slime_tracker.slime_circle_sizes[i]
		
		var dist: Vector2 = slime_positions[i] - $SpellMachineTower.position
		
		# I might need to make powdertoy an autoload singleton.
		
		if $SpellMachineTower.tower_health <= 0:
			#$PowderViewport.queue_free() this segfaults
			print("powder toy freed")
		
		if dist.x < 1000 && dist.y < 1000:
			var powder_x: int = 120-(60-(dist.x/powder_scale)) + powder_offset_x
			var powder_y: int = (dist.y/powder_scale) + powder_offset_y
			
			#var slime_powder = $PowderViewport.powder_instance.collide_slime(Vector2(powder_x, powder_y), 10)
			#print(slime_powder)
			#powder_toy.clear_sim_area(wall_offset, wall_offset, width - (wall_offset*2), border)
			
			# slimes tunnel into your tower
			#$PowderViewport.powder_instance.powder_toy.clear_sim_area(powder_x, powder_y, slime_circle_size, slime_circle_size)
			
			$PowderViewport.powder_instance.circle(Vector2(powder_x,powder_y), slime_circle_size, element)
	
	if Input.is_action_pressed("cam_left"):
		level_camera.position.x -= camera_move_speed * delta
	if Input.is_action_pressed("cam_right"):
		level_camera.position.x += camera_move_speed * delta
	if Input.is_action_pressed("cam_up"):
		level_camera.position.y -= camera_move_speed/2.0 * delta
	if Input.is_action_pressed("cam_down"):
		level_camera.position.y += camera_move_speed/2.0 * delta
		
		
		
	elif Input.is_physical_key_pressed(KEY_E):
		$PowderViewport.powder_instance.polygon(Vector2(60,60), 30.0, 8, 2, 2)

	# Determine the camera's relative position to the center and call face_left or face_right
	var camera_center_x: float = level_camera.position.x
	var screen_center_x: float = $SpellMachineTower.position.x

	if camera_center_x > screen_center_x:
		$SpellMachineTower.face_left()
	else:
		$SpellMachineTower.face_right()



# I need to make slimes damage the tower's main health
