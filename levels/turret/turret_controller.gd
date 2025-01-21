class_name Turret
extends Node2D

@onready var smp = $turret_state

@export var input_glyph: InputGlyph
@export var out_of_ammo: OutOfAmmo

@export var collision_area: Area2D
@export var hurtbox: Area2D
@export var turret_barrel: Node2D
@export var firing_position: Node2D

@export var firing_strategy: FiringStrategy
@export var projectile_data: ProjectileData

@export var camera_offset: Vector2

var powderviewport: PowderViewport

@export var face_left: bool = false

@export var disabled: bool = false

var ammo = 0

signal activated(turret: Turret)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if face_left:
		turret_barrel.flip_v = true
		turret_barrel.rotation = PI
		
	ammo = firing_strategy.ammo

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not powderviewport:
		powderviewport = PowderController.powder_toy
		return
	
	if disabled:
		input_glyph.disabled = true
		return
	else:
		input_glyph.disabled = false
	
	if collision_area.has_overlapping_bodies():
		smp.set_trigger("player_contact")
	else:
		smp.set_trigger("player_gone")

func _on_turret_state_transited(from: Variant, to: Variant) -> void:
	pass # Replace with function body.

func _on_turret_state_updated(state: Variant, delta: Variant) -> void:
	if disabled:
		return
	
	match state:
		"inactive":
			input_glyph.hide()
		"activatable":
			input_glyph.show()
			if Input.is_action_just_pressed("interact") and not GunUtils.active_turret:
				input_glyph.hide()
				GunUtils.set_active_turret(self)
				PlayerState.active_cam.x_offset += camera_offset.x
				PlayerState.active_cam.y_offset += camera_offset.y
				powderviewport.circle(global_position, 10, 114)
				
				GunUtils.set_active_turret(self)
				smp.set_trigger("activated")
		"active":
			if Input.is_action_just_pressed("interact"):
				GunUtils.remove_active_turret()
				smp.set_trigger("deactivated")
				PlayerState.active_cam.x_offset -= camera_offset.x
				PlayerState.active_cam.y_offset -= camera_offset.y
				
			turret_barrel.handle_rotation()
			
			if Input.is_action_pressed("primary_fire"):
				smp.set_trigger("fire")
		"firing":				
			turret_barrel.handle_rotation()
				
			if ammo <= 0:
				smp.set_trigger("out_of_ammo")
				GunUtils.remove_active_turret()
				PlayerState.active_cam.x_offset -= camera_offset.x
				PlayerState.active_cam.y_offset -= camera_offset.y
				return
			
			if not firing_strategy.off_cooldown(self):
				return
				
			if not Input.is_action_pressed("primary_fire"):
				smp.set_trigger("end_firing")
				
			GunUtils.fire_projectile(
			 projectile_data.projectile_scene_path,
			 firing_position.global_position,
			 projectile_data.damage,
			 turret_barrel.rotation,
			 firing_strategy.velocity,
			 projectile_data.max_lifespan,
			 projectile_data.post_hit_lifespan,
			 projectile_data.mass,
			 firing_strategy.shake,
			 0
			)
				
			if not SoundManager.is_playing(projectile_data.sound):
				SoundManager.play_sfx(projectile_data.sound, 0, projectile_data.sound_db, 1)
			
			ammo -= 1
			firing_strategy.register_shot_fired(self)
		"out_of_ammo":
			out_of_ammo.active = true
			if GunUtils.active_turret == self:
				GunUtils.active_turret = null
				PlayerState.active_cam.x_offset -= camera_offset.x
				PlayerState.active_cam.y_offset -= camera_offset.y


func _on_powder_viewport_ready() -> void:
	pass


func _on_turret_hurtbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
