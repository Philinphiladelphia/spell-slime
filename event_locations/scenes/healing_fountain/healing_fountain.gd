extends Node2D

@export var powder: PowderViewport
@export var fountain_powder_points: Array[Vector2]

@export var graph: WorldmapGraph

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var points : Array[Vector2] = []
	
	for i in len(graph.node_datas):
		var rel_pos: Vector2 = graph.get_node_position(i)
		points.append(rel_pos + graph.global_position)
	powder.draw_lines_between_points(points, 5, 17)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
