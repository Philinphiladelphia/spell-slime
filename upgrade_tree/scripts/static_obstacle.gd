extends StaticBody2D

signal insert_powder_circle(x: int, y: int, type: int, size: int)

var damage = 1

var fade_duration = 0.5
var fade_speed = 0.05
var start_fade = false

var fade_timer : Timer

var death_timer : Timer

var slimes_hit = {}

@export var on_hit_animation =  preload("res://upgrade_tree/scenes/on_hit_animation.tscn")

@export var projectile_on_hit_sound = "slime_impact_2"

@export var randomize_impact_sound = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	death_timer = Timer.new()
	death_timer.wait_time = fade_duration
	death_timer.one_shot = true
	add_child(death_timer)
	death_timer.connect("timeout", _on_die)
	
	fade_timer = Timer.new()
	fade_timer.wait_time = 1
	fade_timer.one_shot = true
	add_child(fade_timer)
	fade_timer.connect("timeout", _start_fade)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_fade:
		damage = 0
		set_modulate(lerp(get_modulate(), Color(1,1,1,0), delta+fade_speed))

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.get_parent().get_parent().apply_damage(damage, global_position)
	
	# only once per slime hit
	var id = body.get_parent().get_parent().get_instance_id()
	if not slimes_hit.keys().has(id):
		on_hit()
		slimes_hit.get_or_add(id)

	fade_timer.start()
	
func on_hit():
	if randomize_impact_sound:
		var random_int = randi() % 9 + 1
		SoundManager.play_sfx("slime_impact_" + str(random_int), 0, -12, 1.5)

	var animation = on_hit_animation.instantiate()
	animation.position = position
	
	# 2.5d, cube root for explostion size
	animation.scale = animation.scale * pow(damage, 0.33)

	get_parent().add_child(animation)

func _start_fade() -> void:
	start_fade = true
	death_timer.start()

func _on_die() -> void:
	queue_free()
