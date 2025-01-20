extends Node2D

@export var snake_segments: Array[SoftBody2D]
var segment_forces: Array[Vector2]

@export var snake_head: SoftBody2D
@export var snake_tail: SoftBody2D

@onready var smp = $StateMachinePlayer

var raised_time: float = 0.0
var strike_time: float = 0.0
var telegraph_time: float = 0.0

@export var raise: float = 5
@export var strike: float = 0.75
@export var telegraph: float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(snake_segments)):
		segment_forces.append(Vector2(0,0))

func _physics_process(delta: float) -> void:
	for i in range(len(snake_segments)):
		snake_segments[i].apply_force(segment_forces[i])

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
				smp.set_trigger("telegraph")
		
		"telegraph":
			telegraph_time += delta
			
			snake_tail.get_centerish_body().freeze = true
			
			var direction: Vector2 = $player.slime_position + Vector2(0, -350) - snake_head.get_bones_center_position()
			snake_head.apply_force(direction.normalized() * 2000)
			
			if telegraph_time >= telegraph:
				telegraph_time = 0
				smp.set_trigger("strike")
				
		"strike":
			strike_time += delta
			
			var direction: Vector2 = $player.slime_position - snake_head.get_bones_center_position()
			snake_head.apply_force(direction.normalized() * 1700)
			
			if strike_time >= strike:
				snake_tail.get_centerish_body().freeze = false
				strike_time = 0
				smp.set_trigger("raise")
