extends "res://event_locations/event_base.gd"

@export var spell_vehicle: SpellVehicle
@export var grandpa: Node2D
@export var gpa_second_location: Node2D
@export var gpa_third_location: Node2D
@export var powder_viewport: PowderViewport
@export var sustain_powder: SustainPowder
@export var sustain_powder2: SustainPowder

@export var stage_lighting: CanvasModulate

@export var day_env: Node2D
@export var evil_env: Node2D
@export var day_sky: Node2D
@export var evil_sky: Node2D

@export var powder_second_location: Node2D
@export var powder_third_location: Node2D
@export var powder_fourth_location: Node2D

@export var turret: Turret

@export var spawner1: Spawner
@export var spawner2: Spawner
@export var spawner3: Spawner

@export var slime_tracker: Node
@export var level_ui: LevelUIController

@export var front_door: TileMapLayer

@export var teleport_animation: PackedScene = preload("res://slimes/player_slime/scenes/teleport_animation.tscn")

@onready var tween: Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_BOUNCE)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	spell_vehicle.set_vehicle_state(false)
	
	dialogue_layer.play_next_dialogue()
	
	level_ui.init_level_ui(slime_tracker)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	slime_tracker.set_slime_goal_position(player.slime_position)
	
	if dialogue_layer.dialogue_index >= 6:
		$Camera2D.apply_shake(2)
		$exit_portal.show()
	
func _on_dialogue_layer_dialogue_ended() -> void:
	if dialogue_layer.dialogue_index == 1:
		tutorial_layer.set_tutorial_text("explore the house")
		
	if dialogue_layer.dialogue_index == 2:
		tutorial_layer.set_tutorial_text("get upstairs, defend the house")
		
	if dialogue_layer.dialogue_index == 3:
		tutorial_layer.set_tutorial_text("defeat the enemy slime with the dash orb (Q)")
		player.dash_disabled = false
		spawner1.start_spawns()
		level_ui.show()
		
	if dialogue_layer.dialogue_index == 4:
		tutorial_layer.set_tutorial_text("defeat the enemy slimes with spells (right click + charge)")
		player.cast_disabled = false
		powder_viewport.global_position = powder_third_location.global_position
		spawner2.start_spawns()
		level_ui.show()
		
	if dialogue_layer.dialogue_index == 5:
		tutorial_layer.set_tutorial_text("defeat the slime horde with the turret (e to activate)")
		turret.disabled = false
		powder_viewport.global_position = powder_fourth_location.global_position
		spawner3.start_spawns()
		level_ui.show()
		
	if dialogue_layer.dialogue_index == 6:
		level_ui.hide()
		$exit_portal.activated = true
		$exit_portal.suck_slime = true


func set_color(color: Color):
	stage_lighting.color = color

func _on_input_glyph_activated() -> void:
	$InputGlyph.disabled = true
	
	SoundManager.play_sfx("bell1", 0, 0, 1)
	tutorial_layer.set_tutorial_text("")
	
	player.smp.set_trigger("deactivate")
	
	spell_vehicle.set_vehicle_state(true)
	
	$music.stop()
	
	$Camera2D.apply_shake(10)
	sustain_powder2.sustain_powder(spell_vehicle.global_position + Vector2(0, -50), 2, 129)
	sustain_powder.sustain_powder(spell_vehicle.global_position, 10, 49)
	
	await get_tree().create_timer(5.0).timeout
	$Camera2D.apply_shake(10)
	SoundManager.play_sfx("harpoon", 0, -5, 1)
	turret.show()
		
	front_door.queue_free()
	
	tween.tween_method(set_color, stage_lighting.color, Color(0.4, 0.4, 0.4, 1), 3)

	await get_tree().create_timer(1.0).timeout
	SoundManager.play_sfx("bell4", 0, 0, 0.7)
	SoundManager.play_sfx("harpoon", 0, -5, 1)
	$Camera2D.apply_shake(10)
	spell_vehicle.turret.hide()
	await get_tree().create_timer(1.0).timeout
	SoundManager.play_sfx("bell2", 0, 0, 0.7)
	SoundManager.play_sfx("harpoon", 0, -5, 1)
	$Camera2D.apply_shake(10)
	spell_vehicle.boiler.hide()
	await get_tree().create_timer(1.0).timeout
	SoundManager.play_sfx("bell3", 0, 0, 0.7)
	SoundManager.play_sfx("harpoon", 0, -5, 1)
	$Camera2D.apply_shake(10)
	spell_vehicle.gears.hide()
	await get_tree().create_timer(1.0).timeout
	SoundManager.play_sfx("bell1", 0, 0, 1.2)
	SoundManager.play_sfx("harpoon", 0, -5, 1)
	$Camera2D.apply_shake(10)
	spell_vehicle.standpipe.hide()
	
	for child in $ticking.get_children():
		child.stop()
	
	await get_tree().create_timer(3.0).timeout
	
	spell_vehicle.set_vehicle_state(false)
	
	SoundManager.play_sfx("click", 0, 5, 0.7)
	stage_lighting.color = Color(0.4, 0.4, 0.4, 1)
	
	day_env.hide()
	evil_env.show()
	
	day_sky.hide()
	evil_sky.show()
	
	
	await get_tree().create_timer(5.0).timeout
	
	SoundManager.play_bgm("candle_flame",0, -6, 0.8)

func _on_node_end() -> void:
	await get_tree().create_timer(8).timeout
	
	powder_viewport.global_position = powder_second_location.global_position
	
	teleport_grandpa(gpa_second_location.global_position)
	
	tutorial_layer.set_tutorial_text("")
	dialogue_layer.play_next_dialogue()

func teleport_grandpa(pos: Vector2):
	grandpa.reset()
	grandpa.global_position = pos
	var teleport: AnimatedSprite2D = teleport_animation.instantiate()
	teleport.global_position = grandpa.global_position
	get_tree().root.add_child(teleport)
	SoundManager.play_sfx("harpoon", 0, -12, 1)

func _on_dialogue_collider_body_entered(body: Node2D) -> void:
	if dialogue_layer.dialogue_index == 2:
		tutorial_layer.set_tutorial_text("")
		teleport_grandpa(gpa_third_location.global_position)
		dialogue_layer.play_next_dialogue()

func _on_spawner_depleted() -> void:
	level_ui.hide()
	teleport_grandpa(player.slime_position + Vector2(0, -20))
	tutorial_layer.set_tutorial_text("")
	dialogue_layer.play_next_dialogue()

func _on_exit_portal_portal_entered() -> void:
	SoundManager.stop_all()
	SceneLoader.load_scene("res://overworld/scenes/base_overworld.tscn")
