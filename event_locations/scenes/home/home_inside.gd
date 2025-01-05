extends "res://event_locations/event_base.gd"

@export var spell_vehicle: Node2D
@export var second_dialogue_collider: Area2D
@export var grandpa: Node2D
@export var gpa_second_location: Node2D
@export var gpa_teleport_animation: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	spell_vehicle.set_vehicle_state(false)
	
	dialogue_layer.play_next_dialogue()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	#tutorial_layer.set_tutorial_text("scatman")
	
	if second_dialogue_collider.has_overlapping_bodies() and dialogue_layer.dialogue_index == 1:
		grandpa.global_position = gpa_second_location.global_position
		gpa_teleport_animation.play()
		SoundManager.play_sfx("harpoon", 0, -12, 1)
		tutorial_layer.set_tutorial_text("")
		dialogue_layer.play_next_dialogue()
		

func _on_dialogue_layer_dialogue_ended() -> void:
	if dialogue_layer.dialogue_index == 1:
		tutorial_layer.set_tutorial_text("explore the house")
		
	if dialogue_layer.dialogue_index == 2:
		tutorial_layer.set_tutorial_text("activate the spell machine")
