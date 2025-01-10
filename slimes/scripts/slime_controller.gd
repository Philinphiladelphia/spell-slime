extends Node2D

var max_health: float = 0.0

var health: float = max_health

var bone_number: int = 0
var health_offset: Vector2 = Vector2(0,0)
var jump_power: float = 800

var slime_position: Vector2
var garbage_collect: bool = false
var local_move_direction: Vector2 = Vector2(1, -1)

# powder_stuff
var go_right: bool = false
var is_powdering: int = 0
var powder_timer : Timer

var element: int = 2
var element_circle_size: int = 1

var jump_interval: float = 2.5
var powder_interval: float = 6
var powder_duration: float = 1

var upright_torque: float = 10000

var powder_warning_time: float = 1

var damage: float = 0

var touching_something: bool = false

var slime_powder_shader: ShaderMaterial =  preload("res://shaders/scenes/rainbow_shader.tres")
var slime_warning_shader: ShaderMaterial =  preload("res://shaders/scenes/shine.tres")

var normal_stiffness: float = 0

var jump_timer : Timer
var garbage_collect_timer : Timer
var garbage_wait: float = 3

var is_dead: bool = false

var original_color: Color = Color(1, 1, 1, 1)

@export var decorations: Array[Node2D]

# slimes should be able to jump over the tower and reverse course.

func set_go_right(value: bool)-> void:
	go_right = value
	
func set_element(value: bool) -> void:
	element = value

func set_original_color(color: Color) -> void:
	original_color = color
	$slime_soft_body.modulate = color
	$slime_hitbox/PointLight2D.color = color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	for sprite in decorations:
		add_child(sprite)
	
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
	var random_offset: float = randf_range(-jump_interval/5.0, jump_interval/5.0)
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
	var random_offset: float = randf_range(-jump_interval/5.0, jump_interval/5.0)
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
		var random_offset: float = randf_range(-powder_interval/5.0, powder_interval/5.0)
		powder_timer.wait_time = powder_interval + random_offset
	else:
		powder_timer.wait_time = powder_duration
	
func _disable_powdering() -> void:
	is_powdering = 0


func jump(jump_direction: Vector2)-> void:
	SoundManager.play_sfx("drop1", 0, -6, 1)
	get_child(0).apply_impulse(jump_direction * jump_power)

func set_max_health(amount: float) -> void:
	max_health = amount
	$health_bar.set_max_health(amount)
	$damage_bar.set_max_health(amount)
	
func set_health(amount: float) -> void:
	if amount <= max_health:
		health = amount
		$health_bar.current_health = health
		$damage_bar.current_health = health
	else:
		print("Slime health is above health max")

func apply_damage(amount: float) -> void:
	health -= amount
	$health_bar.current_health = health
	$health_bar.show()
	
	$damage_bar.current_health = health
	$damage_bar.show()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	slime_position = $slime_soft_body.get_bones_center_position()

	$slime_hitbox.global_position = slime_position

	var rigidbody = $slime_soft_body.get_rigid_bodies()[0].rigidbody
	var angle_difference = wrapf(-rigidbody.rotation, -PI, PI)
	$slime_soft_body.constant_torque = angle_difference * upright_torque  # Adjust the multiplier as needed

	if len(decorations) > 0:
		for decoration in decorations:
			decoration.global_position = slime_position
			decoration.rotation = rigidbody.rotation

	var offset: Vector2 = health_offset
	$health_bar.health_bar_offset = offset
	$damage_bar.health_bar_offset = offset
	
	if (health <= 0):
		var current_color: Color = get_modulate()
		var transparent: Color = Color(current_color.r, current_color.g, current_color.b, 0)
		set_modulate(lerp(current_color, transparent, 0.1))
		$slime_soft_body.stiffness = 30
		
		if not is_dead:
			kill_slime()

func enable_light() -> void:
	$slime_hitbox/PointLight2D.enabled = true

func kill_slime() -> void:
	SoundManager.play_sfx("enemy_down", 0, -12, 0.5)
	
	is_powdering = 0
	is_dead = true
	
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
