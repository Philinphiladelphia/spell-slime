extends Node2D

@export var dialogue_layer: CanvasLayer
@export var tutorial_layer: CanvasLayer

@export var grandpa: Node2D
@export var player: Node2D
@export var cursor_radials: Node2D
@export var gpa_collision_area: Area2D
@export var player_collision_area: Area2D

@export var door_area: Area2D
@export var door_glyph: Node2D

var door_active: bool = false

@onready var pause_screen: PackedScene = preload("res://maaack/scenes/overlaid_menus/pause_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_bgm("birds_singing")
	dialogue_layer.play_next_dialogue()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:		
	if dialogue_layer.has_active_dialogue:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.cursor_radials.hide()
		tutorial_layer.set_tutorial_text("")
		grandpa.is_active = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		player.cursor_radials.show()
				
		if not gpa_collision_area.has_overlapping_bodies():
			grandpa.is_active = true
		else:
			grandpa.is_active = false
	
		if dialogue_layer.dialogue_index == 1:
			tutorial_layer.set_tutorial_text("hold and release left mouse to jump\nhelp grandpa get home")
			
			if player_collision_area.has_overlapping_bodies() and gpa_collision_area.has_overlapping_bodies():	
				dialogue_layer.play_next_dialogue()
				
		elif dialogue_layer.dialogue_index == 2:
			tutorial_layer.set_tutorial_text("go to the door and press " + door_glyph.displayed_key + " to enter")
				
	if Input.is_action_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var pause: Node = pause_screen.instantiate()
		dialogue_layer.add_child(pause)


func _on_dialogue_layer_dialogue_ended() -> void:
	if dialogue_layer.dialogue_index == 2:
		door_active = true


func _on_input_glyph_activated() -> void:
	SceneLoader.load_scene("res://event_locations/scenes/home/home_inside.tscn")
