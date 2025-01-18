extends Node2D

@export var snake_head: SoftBody2D
@export var snake_tail: SoftBody2D

@onready var smp = $StateMachinePlayer

var raised_time: float = 0.0
var strike_time: float = 0.0

var raise: float = 5
var strike: float = 0.75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply_damage(amount: int):
	pass

func _on_state_machine_player_updated(state: Variant, delta: Variant) -> void:
	match state:
		"raised":
			raised_time += delta
			
			var slime_pos_difference: float = $player.slime_position.x - snake_head.get_bones_center_position().x
			
			var direction: Vector2 = snake_tail.get_bones_center_position() + Vector2(slime_pos_difference/3, -300) - snake_head.get_bones_center_position()
			snake_head.apply_force(direction.normalized() * 2000)
			
			if raised_time >= raise:
				raised_time = 0
				smp.set_trigger("strike")
		"strike":
			strike_time += delta
			
			var direction: Vector2 = $player.slime_position - snake_head.get_bones_center_position()
			snake_head.apply_force(direction.normalized() * 1700)
			
			if strike_time >= strike:
				strike_time = 0
				smp.set_trigger("raise")
