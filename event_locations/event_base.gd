extends Node2D

@export var dialogue_layer: CanvasLayer
@export var tutorial_layer: CanvasLayer

@export var player: PlayerController

@onready var pause_screen: PackedScene = preload("res://maaack/scenes/overlaid_menus/pause_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:		
	if dialogue_layer.has_active_dialogue:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
	if Input.is_action_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var pause: Node = pause_screen.instantiate()
		dialogue_layer.add_child(pause)
