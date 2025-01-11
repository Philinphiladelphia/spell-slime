extends "res://event_locations/event_base.gd"

@export var spell_vehicle: SpellVehicle
@export var grandpa: Node2D
@export var gpa_second_location: Node2D
@export var gpa_teleport_animation: AnimatedSprite2D
@export var powder_viewport: PowderViewport
@export var sustain_powder: SustainPowder

@export var stage_lighting: CanvasModulate

@export var day_env: Node2D
@export var evil_env: Node2D
@export var day_sky: Node2D
@export var evil_sky: Node2D

@export var powder_second_location: Node2D

@export var turret: Turret
@export var spawner: Node2D
@export var slime_tracker: Node

@export var front_door: TileMapLayer

@onready var tween: Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_BOUNCE)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	spell_vehicle.set_vehicle_state(false)
	
	dialogue_layer.play_next_dialogue()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	slime_tracker.set_slime_goal_position(player.slime_position)
	
func stop_audio():
	for child in get_children():
		if child is AudioStreamPlayer2D:
			child.stop()

func _on_dialogue_layer_dialogue_ended() -> void:
	if dialogue_layer.dialogue_index == 1:
		tutorial_layer.set_tutorial_text("explore the house")
		
	if dialogue_layer.dialogue_index == 2:
		tutorial_layer.set_tutorial_text("activate the spell machine")

func set_color(color: Color):
	stage_lighting.color = color

func _on_input_glyph_activated() -> void:
	SoundManager.play_sfx("bell1", 0, 0, 1)
	
	player.can_jump = false
	
	sustain_powder.sustain_powder(spell_vehicle.global_position, 20, 49)
	stop_audio()
	
	await get_tree().create_timer(5.0).timeout
	
	tutorial_layer.set_tutorial_text("")
	
	day_env.hide()
	evil_env.show()
	
	day_sky.hide()
	evil_sky.show()
	
	turret.show()
		
	front_door.queue_free()
	
	tween.tween_method(set_color, stage_lighting.color, Color(0.4, 0.4, 0.4, 1), 3)

	await get_tree().create_timer(1.0).timeout
	SoundManager.play_sfx("bell1", 0, 0, 0.7)
	spell_vehicle.turret.hide()
	await get_tree().create_timer(1.0).timeout
	SoundManager.play_sfx("bell2", 0, 0, 0.7)
	spell_vehicle.boiler.hide()
	await get_tree().create_timer(1.0).timeout
	SoundManager.play_sfx("bell3", 0, 0, 0.7)
	spell_vehicle.gears.hide()
	await get_tree().create_timer(1.0).timeout
	SoundManager.play_sfx("bell4", 0, 0, 0.7)
	spell_vehicle.standpipe.hide()
	
	await get_tree().create_timer(3.0).timeout
	
	SoundManager.play_sfx("click", 0, 0, 0.7)
	stage_lighting.color = Color(0.4, 0.4, 0.4, 1)
	
	await get_tree().create_timer(5.0).timeout
	
	SoundManager.play_bgm("candle_flame",0, 0, 0.8)

func _on_node_end() -> void:
	await get_tree().create_timer(8).timeout
	
	player.can_jump = true
	powder_viewport.global_position = powder_second_location.global_position
	
	grandpa.position = gpa_second_location.position
	#grandpa.global_position = gpa_second_location.global_position
	gpa_teleport_animation.play()
	SoundManager.play_sfx("harpoon", 0, -12, 1)
	tutorial_layer.set_tutorial_text("")
	dialogue_layer.play_next_dialogue()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	spawner.start_spawns()
