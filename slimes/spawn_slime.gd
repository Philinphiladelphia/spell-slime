class_name Spawner
extends Node2D

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

var super_small_slime: PackedScene = preload("res://slimes/scenes/super_small_slime.tscn")
var super_med_slime: PackedScene = preload("res://slimes/scenes/super_med_slime.tscn")
var small_slime: PackedScene = preload("res://slimes/scenes/small_slime.tscn")
var med_slime: PackedScene = preload("res://slimes/scenes/med_slime.tscn")
var large_slime: PackedScene = preload("res://slimes/scenes/large_slime.tscn")

enum SlimeType { SUPER_SMALL, SUPER_MED, SMALL, MEDIUM, LARGE }

var slime_types: Dictionary = {
	SlimeType.SUPER_SMALL: super_small_slime,
	SlimeType.SUPER_MED: super_med_slime,
	SlimeType.SMALL: small_slime,
	SlimeType.MEDIUM: med_slime,
	SlimeType.LARGE: large_slime,
}

var default_delays: Dictionary = {
	SlimeType.SUPER_SMALL: 1.0,
	SlimeType.SUPER_MED: 2.0,
	SlimeType.SMALL: 1.0,
	SlimeType.MEDIUM: 2.0,
	SlimeType.LARGE: 3.0
}

var max_small_slimes: int = 100
var max_med_slimes: int = 100
var max_large_slimes: int = 100

var slime_cooldown: float = 0.3
var last_spawn_time: float = 0.0

var enable_light: bool = false

var slime_goal_position: Vector2 = Vector2(0,0)

var _slime_types: Array[float] = []
var _delays: Array[float] = []
var _elements: Array[float] = []
var _decorations: Array = []

var spawner_depleted: bool = false

signal active
signal depleted

var spawn_active : bool = false

@export var slime_data_file_path: String = "res://levels/moonswept_fields/day/spawner_json/slime_data.json"
@export var player_collider: Area2D

var next_spawn_time: float = 0.0



func load_slime_data() -> void:
	var file: FileAccess = FileAccess.open(slime_data_file_path, FileAccess.READ)
	if file:
		var json: JSON = JSON.new()
		var file_text: String = file.get_as_text()
		json.parse(file_text)
		var data: Array = json.data
		for entry in data:
			_slime_types.append(entry["type"])
			_elements.append(entry["element"])
			_delays.append(entry["delay"])
			_decorations.append(entry["decorations"])
		file.close()

func start_spawns():
	spawn_active = true
	
func _ready() -> void:
	randomize()
	load_slime_data()

func _on_slime_spawn_timer_timeout() -> void:
	if _slime_types.size() == 0:
		if len(get_children()) == 0:
			spawner_depleted = true
			depleted.emit()
		return
	
	var next_slime_type: int = _slime_types.pop_front()
	var next_slime_element: int = _elements.pop_front()
	var decorations: Array = _decorations.pop_front()
	
	spawn_slime(next_slime_type, next_slime_element, decorations)
	spawn_slime_helper()

func _process(delta: float) -> void:
	# manage spawned slimes and their behavior
	slime_positions.clear()
	powder_activated_bitmap.clear()
	slime_elements.clear()
	slime_circle_sizes.clear()
	slime_damages.clear()
	current_slime_health = 0.0
	current_max_slime_health = 0.0
	
	if player_collider:
		if spawn_active == false and player_collider.has_overlapping_bodies():
			active.emit()
			start_spawns()
	
	for child in get_children():
		var slime: Node = child.get_child(0)
		slime_positions.append(slime.slime_position)
		if slime.slime_position.x < slime_goal_position.x:
			slime.go_right = false
		else:
			slime.go_right = true
			
		var slime_dist: Vector2 = slime.slime_position - slime_goal_position
		
		if slime_dist.length() > 8000 and not slime.is_dead:
			print("Slime off screen, killing")
			slime.kill_slime()
		
		powder_activated_bitmap.append(slime.is_powdering)
		slime_elements.append(slime.element)
		slime_circle_sizes.append(slime.element_circle_size)
		slime_damages.append(slime.damage)
		
		if not slime.is_dead:
			current_slime_health += slime.health
			current_max_slime_health += slime.max_health

	if not spawn_active:
		return

	# Check if it's time to spawn the next slime
	if Time.get_ticks_msec() >= next_spawn_time and not spawner_depleted:
		_on_slime_spawn_timer_timeout()

func set_slime_goal_position(value: Vector2) -> void:
	slime_goal_position = value

func spawn_slimes_with_delay(slime_types: Array[float], delays: Array[float] = [], elements: Array[float] = []) -> void:
	_slime_types = slime_types
	_delays = delays
	_elements = elements
	spawn_slime_helper()
		
func spawn_slime_helper() -> void:
	next_spawn_time = Time.get_ticks_msec() + int(_delays.pop_front() * 1000)

func spawn_slime(slime_type: int, element: int, decorations: Array):
	var instance = slime_types[slime_type].instantiate()
	
	for dec_name in decorations:
		if not DecorationsMap.decorations.has(dec_name):
			print("Decoration not found: " + dec_name)
			continue
		
		var dec_tex = load(DecorationsMap.decorations[dec_name])
		var dec_sprite: Sprite2D = Sprite2D.new()
		dec_sprite.texture = dec_tex
		dec_sprite.scale = Vector2(0.75, 0.75)
		instance.slime_node.decorations.append(dec_sprite)
	
	instance.get_child(0).slime_warning_shader = shine_shader
	instance.get_child(0).slime_powder_shader = shine_shader
	if enable_light:
		instance.get_child(0).enable_light()
	
	# apply random impulse
	var random_vector = Vector2.UP.rotated(randf_range(0, 2*PI))
	instance.slime_node.jump(random_vector, 0.2)
	
	add_child(instance)
	instance.set_element(element)

func get_random_shader() -> ShaderMaterial:
	return shaders[randi() % shaders.size()]

func _input(event: InputEvent) -> void:
	var current_time: float = Time.get_ticks_msec() / 1000.0
	if current_time - last_spawn_time < slime_cooldown:
		return

	var pos: Vector2 = get_global_mouse_position()
