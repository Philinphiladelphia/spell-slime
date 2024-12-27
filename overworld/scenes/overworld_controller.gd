extends Node2D

@export var overworld: WorldmapView
@export var worldgraph: NodePath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	overworld.set_node_state(worldgraph, 0, 1)
	overworld.recalculate_map()
	print(overworld.get_node_state(worldgraph, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
