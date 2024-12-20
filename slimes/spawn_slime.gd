extends Node2D

var small_slime: PackedScene = preload("res://slimes/scenes/small_slime.tscn")
var med_slime: PackedScene = preload("res://slimes/scenes/med_slime.tscn")
var large_slime: PackedScene = preload("res://slimes/scenes/large_slime.tscn")

var rainbow_shader: ShaderMaterial = preload("res://shaders/scenes/rainbow_shader.tres")
var clear_shader: ShaderMaterial = preload("res://shaders/scenes/clear.tres")
var shine_shader: ShaderMaterial = preload("res://shaders/scenes/shine.tres")
var gameboy_shader: ShaderMaterial = preload("res://shaders/scenes/gameboy.tres")

var shaders: Array[ShaderMaterial] = [rainbow_shader]

var slime_positions: PackedVector2Array
var powder_activated_bitmap: PackedInt32Array

var slime_elements: PackedInt32Array
var slime_circle_sizes: PackedInt32Array

var slime_damages: PackedInt32Array

var current_slime_health: float = 0.0
var current_max_slime_health: float = 0.0
# don't use slime positions. 
#Use slime x and y distance from the center of the powder toy. Much more useful for spawning.


var max_small_slimes: int = 100
var max_med_slimes: int = 100
var max_large_slimes: int = 100

var slime_cooldown: float = 0.3
var last_spawn_time: float = 0.0

var small_slime_count: int = 0
var med_slime_count: int = 0
var large_slime_count: int = 0

var go_right: bool = false

var enable_light: bool = false

var tower_midpoint: float = 0.0

@export var spawntimer: Timer

var _slime_types: Array = []
var _delays: Array = []
var _elements: Array = []

var spawner_depleted: bool = false

# Path to the JSON file
var colors_file_path: String = "res://addons/powder_toy_godot/colors.json"
@export var slime_data_file_path: String = "res://levels/moonswept_fields/day/spawner_json/slime_data.json"

# Dictionary to store colors for each particle type
var slime_colors: Dictionary = {}

var slimes_to_spawn: Array = []
var delays: Array = []
var elements: Array = []

func load_colors() -> void:
	var file: FileAccess = FileAccess.open(colors_file_path, FileAccess.READ)
	if file:
		var json: JSON = JSON.new()
		var file_text: String = file.get_as_text()
		json.parse(file_text)
		var data: Dictionary = json.data
		for key: String in data.keys():
			slime_colors[int(key)] = str_to_var(data[key])
		file.close()

func load_slime_data() -> void:
	var file: FileAccess = FileAccess.open(slime_data_file_path, FileAccess.READ)
	if file:
		var json: JSON = JSON.new()
		var file_text: String = file.get_as_text()
		json.parse(file_text)
		var data: Array = json.data
		for entry in data:
			slimes_to_spawn.append(entry["type"])
			elements.append(entry["element"])
			delays.append(entry["delay"])
		file.close()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	load_colors()
	load_slime_data()
	
	#for i in range(5):
		#slimes_to_spawn.append(SlimeType.SMALL)
		#delays.append(1)
		#
	#
	#slimes_to_spawn.append_array([SlimeType.SMALL, SlimeType.MEDIUM, SlimeType.MEDIUM])
	#delays.append_array([1.5, 2.0, 2.0])

	spawn_slimes_with_delay(slimes_to_spawn, delays, elements)
	
func _process(delta: float) -> void:
	slime_positions.clear()
	powder_activated_bitmap.clear()
	
	slime_elements.clear()
	slime_circle_sizes.clear()
	
	slime_damages.clear()
	
	
	current_slime_health = 0.0
	current_max_slime_health = 0.0
	for child in get_children():
		var slime: Node = child.get_child(0)
		slime_positions.append(slime.slime_position)
		if slime.slime_position.x < tower_midpoint:
			slime.go_right = false
		else:
			slime.go_right = true
			
		var slime_dist: Vector2 = slime.slime_position - get_parent().get_parent().spelltowernode.position
		
		if slime_dist.length() > 8000 && not slime.is_dead:
			print("Slime off screen, killing")
			slime.kill_slime()
		
		powder_activated_bitmap.append(slime.is_powdering)
		
		slime_elements.append(slime.element)
		slime_circle_sizes.append(slime.element_circle_size)
		
		slime_damages.append(slime.damage)
		
		if not slime.is_dead:
			current_slime_health += slime.health
			current_max_slime_health += slime.max_health

func set_tower_midpoint(value: float) -> void:
	tower_midpoint = value

enum SlimeType { SMALL, MEDIUM, LARGE }

var default_delays: Dictionary = {
	SlimeType.SMALL: 1.0,
	SlimeType.MEDIUM: 2.0,
	SlimeType.LARGE: 3.0
	}

func spawn_slimes_with_delay(slime_types: Array, delays: Array = [], elements: Array = []) -> void:
	_slime_types = slime_types
	_delays = delays
	_elements = elements
	spawn_slime_helper()
		
func spawn_slime_helper() -> void:
	if _delays.size() == 0:
		spawner_depleted = true
		return
	spawntimer.wait_time = _delays.pop_front()
	spawntimer.start()

# Example usage:
# spawn_slimes_with_delay([SlimeType.SMALL, SlimeType.MEDIUM, SlimeType.LARGE], [1.5, 2.5, 3.5])

func spawn_small_slime(element: int) -> void:
	var instance: Node = small_slime.instantiate()
	small_slime_count += 1
	
	instance.get_child(0).slime_warning_shader = shine_shader
	instance.get_child(0).slime_powder_shader = shine_shader
	if enable_light:
		instance.get_child(0).enable_light()
		
	# order matters
	add_child(instance)
	instance.set_element(element)
	
func spawn_med_slime(element: int) -> void:
	var instance: Node = med_slime.instantiate()
	med_slime_count += 1

	instance.get_child(0).slime_warning_shader = shine_shader
	instance.get_child(0).slime_powder_shader = gameboy_shader
	if enable_light:
		instance.get_child(0).enable_light()
		
	# order matters
	add_child(instance)
	instance.set_element(element)

func spawn_large_slime(element: int) -> void:
	var instance: Node = large_slime.instantiate()
	large_slime_count += 1

	instance.get_child(0).slime_warning_shader = shine_shader
	instance.get_child(0).slime_powder_shader = gameboy_shader
	if enable_light:
		instance.get_child(0).enable_light()
		
	# order matters
	add_child(instance)
	instance.set_element(element)

func get_random_shader() -> ShaderMaterial:
	return shaders[randi() % shaders.size()]

#func inst(pos: Vector2, slime_scene) -> void:
	#pass # this is onclick

# these should be switched out for rebindable controls via actions
func _input(event: InputEvent) -> void:
	var current_time: float = Time.get_ticks_msec() / 1000.0
	if current_time - last_spawn_time < slime_cooldown:
		return

	var pos: Vector2 = get_global_mouse_position()

	if Input.is_key_pressed(KEY_I) and small_slime_count < max_small_slimes:
		spawn_small_slime(4)
		last_spawn_time = current_time
	elif Input.is_key_pressed(KEY_O) and med_slime_count < max_med_slimes:
		spawn_med_slime(49)
		last_spawn_time = current_time
	elif Input.is_key_pressed(KEY_P) and large_slime_count < max_large_slimes:
		spawn_large_slime(121)
		last_spawn_time = current_time


func _on_slime_spawn_timer_timeout() -> void:
	var next_slime_type: int = _slime_types.pop_front()
	var next_slime_element: int = _elements.pop_front()
	match next_slime_type:
		SlimeType.SMALL:
			spawn_small_slime(next_slime_element)
		SlimeType.MEDIUM:
			spawn_med_slime(next_slime_element)
		SlimeType.LARGE:
			spawn_large_slime(next_slime_element)
	
	spawn_slime_helper()
