extends Node2D

var max_health = 0.0

var health = max_health

var bone_number = 0
var health_offset = Vector2(0,0)
var jump_power = 800

var slime_position: Vector2
var garbage_collect = false
var local_move_direction = Vector2(1, -1)

# powder_stuff
var go_right = false
var is_powdering = 0
var powder_timer : Timer

var element = 2
var element_circle_size = 1

var jump_interval = 2.5
var powder_interval = 6
var powder_duration = 1

var powder_warning_time = 1

var damage = 0

var touching_something = false

var slime_powder_shader =  preload("res://shaders/scenes/rainbow_shader.tres")
var slime_warning_shader =  preload("res://shaders/scenes/shine.tres")

var normal_stiffness = 0

var jump_timer : Timer
var garbage_collect_timer : Timer
var garbage_wait = 3

var is_dead = false

# slimes should be able to jump over the tower and reverse course.

func set_go_right(value):
	go_right = value
	
func set_element(value):
	element = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$health_bar.bone_number = bone_number
	$damage_bar.bone_number = bone_number
	
	$health_bar.hide()
	$damage_bar.hide()
	
	normal_stiffness = $slime_soft_body.stiffness
	
	# powder timer
	powder_timer = Timer.new()
	powder_timer.wait_time = 0.1
	add_child(powder_timer)
	powder_timer.connect("timeout", _on_powdering_timeout)
	powder_timer.start()
	
	# jump timer
	jump_timer = Timer.new()
	var random_offset = randf_range(-jump_interval/5.0, jump_interval/5.0)
	jump_timer.wait_time = jump_interval + random_offset
	add_child(jump_timer)
	jump_timer.connect("timeout", _on_jump_timer_timeout)
	jump_timer.start()
	
	# garbage collection
	garbage_collect_timer = Timer.new()
	garbage_collect_timer.wait_time = garbage_wait
	garbage_collect_timer.one_shot = true
	add_child(garbage_collect_timer)
	garbage_collect_timer.connect("timeout", _on_timeout)

# Called when the jump timer times out
func _on_jump_timer_timeout() -> void:
	if touching_something:
		var random_offset = randf_range(-jump_interval/5.0, jump_interval/5.0)
		jump_timer.wait_time = jump_interval + random_offset
		
		var jump_direction : Vector2
		if go_right:
			jump_direction.x = local_move_direction.x
		else:
			jump_direction.x = -local_move_direction.x
			
		jump_direction.y = local_move_direction.y
		jump(jump_direction)
		touching_something = false
	
	# Called when the jump timer times out
func _on_powdering_timeout() -> void:
	is_powdering = 1-is_powdering
	
	if (is_powdering == 1):
		var random_offset = randf_range(-powder_interval/5.0, powder_interval/5.0)
		powder_timer.wait_time = powder_interval + random_offset
	else:
		powder_timer.wait_time = powder_duration
	
func _disable_powdering():
	is_powdering = 0


func jump(jump_direction):
	get_child(0).apply_impulse(jump_direction * jump_power)

func set_max_health(amount):
	max_health = amount
	$health_bar.set_max_health(amount)
	$damage_bar.set_max_health(amount)
	
func set_health(amount):
	if amount <= max_health:
		health = amount
		$health_bar.current_health = health
		$damage_bar.current_health = health
	else:
		print("Slime health is above health max")

func apply_damage(amount):
	health -= amount
	$health_bar.current_health = health
	$health_bar.show()
	
	$damage_bar.current_health = health
	$damage_bar.show()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if powder_timer.time_left < powder_warning_time && is_powdering == 0:
		material = slime_warning_shader
	elif is_powdering == 1:
		material = slime_powder_shader
	else:
		material = null
	
	slime_position = $slime_soft_body.get_bones_center_position()
	
	$slime_hitbox.global_position = slime_position
	
	var offset = health_offset
	$health_bar.health_bar_offset = offset
	$damage_bar.health_bar_offset = offset
	if (health <= 0):
		set_modulate(lerp(get_modulate(), Color(1,1,1,0), 0.1))
		$slime_soft_body.stiffness = 30
		
		if not is_dead:
			kill_slime()
			is_dead = true

func enable_light():
	$slime_hitbox/PointLight2D.enabled = true

func kill_slime():
	is_powdering = 0
	
	garbage_collect_timer.start()
	powder_timer.stop()
	jump_timer.stop()
	
	# take away the slime's physics layer so it squishes easy
	$slime_soft_body.collision_layer = 0
	
	# disable light
	$slime_hitbox/PointLight2D.enabled = false

func _on_timeout() -> void:
	garbage_collect = true

func _on_slime_hitbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	touching_something = true
	

func _on_slime_hitbox_area_entered(area: Area2D) -> void:
	touching_something = true
