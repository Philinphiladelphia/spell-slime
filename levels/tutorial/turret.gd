extends Sprite2D

@export var firing_position: Node2D
@export var max_rotation_speed: float = 0.03

@export var is_active: bool = false

@export var collision_area: Area2D

@export var view: CameraRegionController2D
@export var input_glyph: Node2D

@export var player: Node2D

@export var powderviewport: Node2D

var basic_projectile_scene = preload("res://upgrade_tree/scenes/basic_projectile.tscn")
var firing_timer: float = 0

var firing_interval = 0.1
var shake = 0.1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if collision_area.has_overlapping_bodies():
		input_glyph.show()
		
		if Input.is_action_pressed("interact"):
			view.disabled = false
			is_active = true
			player.is_active = false
	else:
		input_glyph.hide()
		is_active = false
	
	if not is_active:
		return
		
	input_glyph.hide()
		
	if not Input.is_action_pressed("primary_fire"):
		return
	
	firing_timer -= delta
	
	var mouse_direction := (get_global_mouse_position() - firing_position.global_position).normalized()
	
	handle_rotation()
	
	if firing_timer <= 0:
		if not SoundManager.is_playing("harpoon"):
			SoundManager.play_sfx("harpoon", 0, -20, 1)
		
		GunUtils.fire_projectile(
		 basic_projectile_scene,
		 firing_position.global_position,
		 1,
		 rotation,
		 2200,
		 5, 1,
		 0.5,
		 0.1
		)
		
		firing_timer = firing_interval

func handle_rotation() -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	var target_angle: float = (mouse_position - global_position).angle()
	var angle_difference: float = wrapf(target_angle - rotation, -PI, PI)

	if abs(angle_difference) > max_rotation_speed:
		if angle_difference < 0:
			rotation -= max_rotation_speed
		else:
			rotation += max_rotation_speed
	else:
		rotation = target_angle


	
