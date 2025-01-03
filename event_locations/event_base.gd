extends Node2D

@export var dialogue_layer: CanvasLayer
@export var tutorial_layer: CanvasLayer

@export var grandpa: Node2D
@export var player: Node2D
@export var cursor_radials: Node2D

var door_active: bool = false

@onready var pause_screen: PackedScene = preload("res://maaack/scenes/overlaid_menus/pause_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var pause: Node = pause_screen.instantiate()
		dialogue_layer.add_child(pause)
		
	if dialogue_layer.has_active_dialogue:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		cursor_radials.hide()
		tutorial_layer.set_tutorial_text("")
		player.is_active = false
		grandpa.is_active = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		cursor_radials.show()
		player.is_active = true


func _on_dialogue_layer_dialogue_ended() -> void:
	if dialogue_layer.dialogue_index == 2:
		door_active = true
