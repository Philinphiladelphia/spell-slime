extends Node2D

@export var powder: PowderViewport

@export var wood_graph: WorldmapGraph
@export var water_graph: WorldmapGraph

@export var player: PlayerController

var water_count: int = 0
var got_intial_water_count: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var points : Array[Vector2] = []
	
	powder.draw_graph(wood_graph, 3, 17)
	powder.draw_graph(water_graph, 6, 2)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var element_count: int = powder.count_element(2)
	if element_count == 0:
		return
	
	if not got_intial_water_count:
		water_count = element_count
		got_intial_water_count = true
	
	if element_count < water_count:
		powder.circle($gem.global_position, 3, 2)


func _on_heal_timer_timeout() -> void:
	if PlayerState.health == PlayerState.max_health:
		return
	
	if $water_collider.has_overlapping_bodies():
		powder.circle(PlayerState.player_location, 10, 0)
		powder.draw_graph(wood_graph, 3, 17)
		
		player.heal(5)
