class_name DashCollider
extends Area2D

@onready var smp = $StateMachinePlayer

@export var ready_indicator: AnimatedSprite2D
@export var blocked_indicator: AnimatedSprite2D
@export var cooldown_indicator: AnimatedSprite2D

@export var dash_hitbox: Area2D

var current_state: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_state = smp.get_current()


func _on_state_machine_player_updated(state: Variant, delta: Variant) -> void:
	match state:
		"ready":
			ready_indicator.show()
			blocked_indicator.hide()
			cooldown_indicator.hide()
			
		"blocked":
			ready_indicator.hide()
			blocked_indicator.show()
			cooldown_indicator.hide()
			
		"cooldown":
			ready_indicator.hide()
			blocked_indicator.hide()
			cooldown_indicator.show()

func _on_state_machine_player_transited(from: Variant, to: Variant) -> void:
	pass # Replace with function body.
