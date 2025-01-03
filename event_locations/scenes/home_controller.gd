extends Node2D

@export var camera_node: Camera2D
@export var dialogue_layer: CanvasLayer

@export var grandpa: Node2D
@export var player: Node2D
@export var cursor_radials: Node2D
@export var gpa_collision_area: Area2D
@export var player_collision_area: Area2D

@export var door_area: Area2D
@export var door_glyph: Node2D

var home_dialogue = preload("res://clyde/base_dialogue.tscn")

var is_active: bool = false

var current_dialogue

var second_dialogue_spawned: bool = false

var player_collided: bool = false

var door_active: bool = false

@onready var pause_screen: PackedScene = preload("res://maaack/scenes/overlaid_menus/pause_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_dialogue = home_dialogue.instantiate()
	
	current_dialogue.get_child(0).on_dialogue_end.connect(dialogue_end)
	dialogue_layer.add_child(current_dialogue)
	pass # Replace with function body.

func activate_scene():
	player.is_active = true
	
	if not second_dialogue_spawned:
		grandpa.is_active = true
		
	if second_dialogue_spawned:
		door_active = true
		
	is_active = true
	cursor_radials.show()
	
func deactivate_scene():
	player.is_active = false
	grandpa.is_active = false
	is_active = false
	cursor_radials.hide()

func dialogue_end():
	activate_scene()
	
	for child in dialogue_layer.get_children():
		child.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not MouseGlobal.get_mouse_owned() and is_active:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	if Input.is_action_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var pause: Node = pause_screen.instantiate()
		dialogue_layer.add_child(pause)
		
	if gpa_collision_area.has_overlapping_bodies():
		grandpa.is_active = false
		
	if not second_dialogue_spawned and player_collision_area.has_overlapping_bodies() and gpa_collision_area.has_overlapping_bodies():
		deactivate_scene()
		
		current_dialogue = home_dialogue.instantiate()
		current_dialogue.get_child(0).on_dialogue_end.connect(dialogue_end)
		dialogue_layer.add_child(current_dialogue)
		
		second_dialogue_spawned = true
		
	if door_area.has_overlapping_bodies() and door_active:
		door_glyph.show()
		if Input.is_action_pressed("interact"):
			print("GO_INSIDE")
	else:
		door_glyph.hide()
