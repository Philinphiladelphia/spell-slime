extends Node2D

var small_slime = preload("res://slimes/scenes/small_slime.tscn")
var med_slime = preload("res://slimes/scenes/med_slime.tscn")
var large_slime = preload("res://slimes/scenes/large_slime.tscn")

var rainbow_shader = preload("res://shaders/scenes/rainbow_shader.tres")
var clear_shader = preload("res://shaders/scenes/clear.tres")
var shine_shader = preload("res://shaders/scenes/shine.tres")
var gameboy_shader = preload("res://shaders/scenes/gameboy.tres")

var shaders = [rainbow_shader]

var slime_positions: PackedVector2Array
var powder_activated_bitmap: PackedInt32Array

var slime_elements: PackedInt32Array
var slime_circle_sizes: PackedInt32Array

var current_slime_health = 0
var current_max_slime_health = 0
# don't use slime positions. 
#Use slime x and y distance from the center of the powder toy. Much more useful for spawning.


var max_small_slimes = 10
var max_med_slimes = 10
var max_large_slimes = 10

var slime_cooldown = 0.5
var last_spawn_time = 0.0

var small_slime_count = 0
var med_slime_count = 0
var large_slime_count = 0

var go_right = false

var enable_light = false

var tower_midpoint = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
func _process(delta: float) -> void:
	slime_positions.clear()
	powder_activated_bitmap.clear()
	
	slime_elements.clear()
	slime_circle_sizes.clear()
	
	
	current_slime_health = 0
	current_max_slime_health = 0
	for child in get_children():
		var slime = child.get_child(0)
		slime_positions.append(slime.slime_position)
		if slime.slime_position.x < tower_midpoint:
			slime.go_right = false
		else:
			slime.go_right = true
		
		powder_activated_bitmap.append(slime.is_powdering)
		
		slime_elements.append(slime.element)
		slime_circle_sizes.append(slime.element_circle_size)
		
		if not slime.is_dead:
			current_slime_health += slime.health
			current_max_slime_health += slime.max_health

func set_tower_midpoint(value):
	tower_midpoint = value

func spawn_small_slime():
	var instance = small_slime.instantiate()
	small_slime_count += 1
	instance.position = position
	instance.get_child(0).slime_warning_shader = shine_shader
	instance.get_child(0).slime_powder_shader = gameboy_shader
	if enable_light:
		instance.get_child(0).enable_light()
	add_child(instance)
	
func spawn_med_slime():
	var instance = med_slime.instantiate()
	med_slime_count += 1
	instance.position = position
	instance.get_child(0).slime_warning_shader = shine_shader
	instance.get_child(0).slime_powder_shader = gameboy_shader
	if enable_light:
		instance.get_child(0).enable_light()
	add_child(instance)
	
func spawn_large_slime():
	var instance = large_slime.instantiate()
	large_slime_count += 1
	instance.position = position
	instance.get_child(0).slime_warning_shader = shine_shader
	instance.get_child(0).slime_powder_shader = gameboy_shader
	if enable_light:
		instance.get_child(0).enable_light()
	add_child(instance)

func get_random_shader():
	return shaders[randi() % shaders.size()]

func inst(pos, slime_scene):
	pass # this is onclick

# these should be switched out for rebindable controls via actions
func _input(event):
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_spawn_time < slime_cooldown:
		return

	var pos = get_global_mouse_position()

	if Input.is_key_pressed(KEY_I) and small_slime_count < max_small_slimes:
		spawn_small_slime()
		last_spawn_time = current_time
	elif Input.is_key_pressed(KEY_O) and med_slime_count < max_med_slimes:
		spawn_med_slime()
		last_spawn_time = current_time
	elif Input.is_key_pressed(KEY_P) and large_slime_count < max_large_slimes:
		spawn_large_slime()
		last_spawn_time = current_time
