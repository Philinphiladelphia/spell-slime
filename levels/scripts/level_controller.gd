extends Node2D

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
@export var powderviewport: Node

@onready var pause_screen: PackedScene = preload("res://maaack/scenes/overlaid_menus/pause_menu.tscn")

@onready var level_win_screen: PackedScene = preload("res://maaack/scenes/overlaid_menus/level_won_menu.tscn")

@onready var level_lost_screen: PackedScene = preload("res://maaack/scenes/overlaid_menus/level_lost_menu.tscn")

var options_scene: PackedScene
var credits_scene: PackedScene
var sub_menu: PackedScene

var won: bool = false
var lost: bool = false

var max_spellward_hp = 0.0

func load_scene(scene_path : String) -> void:
	SceneLoader.load_scene(scene_path)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tower_element: int = 114 # plant
	
	powderviewport.powder_instance.health_element = 20
	
	powderviewport.powder_instance.polygon(Vector2(60,60), 20.0, 8, 5, tower_element)
	powderviewport.powder_instance.powder_toy.powder_box(40, 120, 80, 75, tower_element)
	
	
	$slime_tracker.set_tower_midpoint(spelltowernode.global_position.x)
	
	powderviewport.powder_instance.powder_toy.flood_powder(60, 60, 28, 0) # diamond
	
	spelltowernode.init_tower_health(tower_health)
	
	$slime_health_layer/HealthBar.init_health(100.0)
	$slime_health_layer/HealthBar._set_health(0.0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spelltowernode.tower_health <= 0 and not lost:
		SoundManager.stop_all()
		lost = true
		var lost_screen: Node = level_lost_screen.instantiate()
		#rewards.global_position = camera_node.global_position
		$slime_health_layer.add_child(lost_screen)
		
	# init powder health. Gotta wait a sec for the initial powder manifests to go off
	var powder_health: float = powderviewport.powder_instance.get_health()
	
	# calculate spellward hp
	var margin_health: int = powder_health - spelltowernode.spellward_health_margin
	if (margin_health > max_spellward_hp):
		spelltowernode.init_spellward_health(margin_health)
		max_spellward_hp = margin_health
		
	# smoking barrel
	
	spelltowernode.set_spellward_health(powder_health - spelltowernode.spellward_health_margin)
	
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
		
		var dist: Vector2 = slime_positions[i] - spelltowernode.position
		
		# I might need to make powdertoy an autoload singleton.
		
		if dist.x < 1000 && dist.y < 1000:
			var powder_x: int = 120-(60-(dist.x/powder_scale)) + powder_offset_x
			var powder_y: int = (dist.y/powder_scale) + powder_offset_y
			
			#var slime_powder = powderviewport.powder_instance.collide_slime(Vector2(powder_x, powder_y), 10)
			#print(slime_powder)
			#powder_toy.clear_sim_area(wall_offset, wall_offset, width - (wall_offset*2), border)
			
			# slimes tunnel into your tower
			#powderviewport.powder_instance.powder_toy.clear_sim_area(powder_x, powder_y, slime_circle_size, slime_circle_size)
			
			powderviewport.powder_instance.circle(Vector2(powder_x,powder_y), slime_circle_size, element)
	
	if Input.is_action_pressed("cam_left"):
		camera_node.position.x -= camera_move_speed * delta
	if Input.is_action_pressed("cam_right"):
		camera_node.position.x += camera_move_speed * delta
	if Input.is_action_pressed("cam_up"):
		camera_node.position.y -= camera_move_speed/2.0 * delta
	if Input.is_action_pressed("cam_down"):
		camera_node.position.y += camera_move_speed/2.0 * delta
		
	if Input.is_action_pressed("pause"):
		var pause: Node = pause_screen.instantiate()
		$slime_health_layer.add_child(pause)
		
	if Input.is_physical_key_pressed(KEY_E):
		powderviewport.powder_instance.polygon(Vector2(60,60), 30.0, 8, 2, 2)

	# Determine the camera's relative position to the center and call face_left or face_right
	var camera_center_x: float = camera_node.position.x
	var screen_center_x: float = spelltowernode.position.x

	if camera_center_x > screen_center_x:
		spelltowernode.face_left()
	else:
		spelltowernode.face_right()



# I need to make slimes damage the tower's main health
