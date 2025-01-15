extends RigidBody2D

signal insert_powder_circle(x: int, y: int, type: int, size: int)

var damage = 1
var post_hit_lifespan = 0.5
var max_projectile_lifespan = 8
var projectile_mass = 2

var died_of_old_age = false
var fade_duration = 0.5
var fade_speed = 0.05
var start_fade = false

var lifespan_timer : Timer
var fade_timer : Timer

var death_timer : Timer

var slimes_hit = {}

@export var on_hit_animation =  preload("res://upgrade_tree/scenes/on_hit_animation.tscn")

@export var projectile_on_hit_sound = "slime_impact_2"

@export var randomize_impact_sound = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mass = projectile_mass
	
	death_timer = Timer.new()
	death_timer.wait_time = fade_duration
	death_timer.one_shot = true
	add_child(death_timer)
	death_timer.connect("timeout", _on_die)
	
	lifespan_timer = Timer.new()
	lifespan_timer.wait_time = max_projectile_lifespan
	lifespan_timer.one_shot = true
	add_child(lifespan_timer)
	lifespan_timer.connect("timeout", _lifespan_end)
	lifespan_timer.start()
	
	fade_timer = Timer.new()
	fade_timer.wait_time = post_hit_lifespan
	fade_timer.one_shot = true
	add_child(fade_timer)
	fade_timer.connect("timeout", _start_fade)
	
func _lifespan_end():
	died_of_old_age = true
	death_timer.start()

func apply_firing_velocity():
	var local_move_direction = Vector2(0, -1).rotated(get_global_transform().get_rotation())
	apply_impulse(local_move_direction * 2000)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_fade or died_of_old_age:
		damage = 0
		set_modulate(lerp(get_modulate(), Color(1,1,1,0), delta+fade_speed))

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	
	# only once per slime hit
	var id = body.get_parent().get_parent().get_instance_id()
	if not slimes_hit.keys().has(id):
		on_hit()
		body.get_parent().get_parent().apply_damage(damage)
		slimes_hit.get_or_add(id)

	fade_timer.start()
	
func on_hit():
	var animation = on_hit_animation.instantiate()
	animation.global_position = global_position
	animation.rotation = rotation + (PI/2.0)
	
	# 2.5d, cube root for explostion size
	animation.scale = animation.scale * pow(damage, 0.33)

	get_tree().root.add_child(animation)
# how to move the powder viewport	

#var viewport = get_node("../../../PowderViewport")
#viewport.position = global_position
#collision_mask = 2

func _start_fade() -> void:
	start_fade = true
	death_timer.start()

func _on_die() -> void:
	queue_free()
