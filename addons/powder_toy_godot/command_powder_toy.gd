class_name PowderViewport
extends Node2D

var powder_toy: PackedScene = preload("res://addons/powder_toy_godot/powder_toy.tscn")

var powder_instance: Node
var health: int = 0

@export var sim_speed: float = 60.0

@export var cam: Camera2D

var ratio = 650.0/200.0

var current_x: float = 0.0
var is_drawing: bool = false
var mouse_pos: Vector2 = Vector2()
var is_right_click: bool = false

var health_element: int = 17
var health_element_count: int = 0

var clear_edges_timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PowderController.set_powder_toy(self)
	powder_instance = powder_toy.instantiate()
	powder_instance.sim_speed = sim_speed
	$SubViewportContainer/SubViewport.add_child(powder_instance)
	
	powder_instance.set_edge_mode(0)
	powder_instance.set_grav_mode(0)

	clear_edges_timer = Timer.new()
	clear_edges_timer.wait_time = 5.0
	add_child(clear_edges_timer)
	clear_edges_timer.connect("timeout", _on_clear_edges_timer_timeout)
	clear_edges_timer.start()

func get_health() -> int:
	return powder_instance.count_element(health_element)
	
func count_element(element: int):
	return powder_instance.count_element(element)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func circle(pos: Vector2, radius: float, element: int) -> void:
	pos = transform_position(pos)
	powder_instance.powder_circle(pos.x, pos.y, radius, element)

func rectangle(top_left: Vector2, width: float, height: float, thickness: float, element: int) -> void:
	top_left = transform_position(top_left)
	var bottom_right: Vector2 = top_left + Vector2(width, height)
	powder_instance.powder_line(top_left.x, top_left.y, bottom_right.x, top_left.y, thickness, element)
	powder_instance.powder_line(bottom_right.x, top_left.y, bottom_right.x, bottom_right.y, thickness, element)
	powder_instance.powder_line(bottom_right.x, bottom_right.y, top_left.x, bottom_right.y, thickness, element)
	powder_instance.powder_line(top_left.x, bottom_right.y, top_left.x, top_left.y, thickness, element)

func square(top_left: Vector2, size: float, thickness: float, element: int) -> void:
	rectangle(top_left, size, size, thickness, element)

func triangle(p1: Vector2, p2: Vector2, p3: Vector2, thickness: float, element: int) -> void:
	p1 = transform_position(p1)
	p2 = transform_position(p2)
	p3 = transform_position(p3)
	powder_instance.powder_line(p1.x, p1.y, p2.x, p2.y, thickness, element)
	powder_instance.powder_line(p2.x, p2.y, p3.x, p3.y, thickness, element)
	powder_instance.powder_line(p3.x, p3.y, p1.x, p1.y, thickness, element)

func polygon(center: Vector2, radius: float, sides: int, thickness: float, element: int) -> void:
	if sides < 3:
		return # A polygon must have at least 3 sides

	center = transform_position(center)
	var angle_step: float = 2 * PI / sides
	var points: PackedVector2Array = []

	for i in range(sides):
		var angle: float = i * angle_step
		var x: float = center.x + radius * cos(angle)
		var y: float = center.y + radius * sin(angle)
		points.append(Vector2(x, y))

	for i in range(sides):
		var start: Vector2 = points[i]
		var end: Vector2 = points[(i + 1) % sides]
		powder_instance.powder_line(start.x, start.y, end.x, end.y, thickness, element)

func line(start: Vector2, end: Vector2, thickness: float, element: int) -> void:
	start = transform_position(start)
	end = transform_position(end)
	powder_instance.powder_line(start.x, start.y, end.x, end.y, thickness, element)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			is_drawing = true
			mouse_pos = event.position
			is_right_click = event.button_index == MOUSE_BUTTON_RIGHT
		else:
			is_drawing = false

	if event is InputEventMouseMotion and is_drawing:
		mouse_pos = event.position

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			is_drawing = true
			mouse_pos = event.position
			is_right_click = event.button_index == MOUSE_BUTTON_LEFT
		else:
			is_drawing = false

	if event is InputEventMouseMotion and is_drawing:
		mouse_pos = event.position

func draw_lines_between_points(points: Array, radius: float, element: int) -> void:
	if points.size() < 2:
		return # Need at least two points to draw a line

	for i in range(points.size() - 1):
		var start: Vector2 = transform_position(points[i])
		var end: Vector2 = transform_position(points[i + 1])
		powder_instance.powder_line(start.x, start.y, end.x, end.y, radius, element)

func _on_clear_edges_timer_timeout() -> void:
	clear_outer_area()

func draw_graph(graph: WorldmapGraph, radius: int, element:int):
	var points : Array[Vector2] = []
	
	for i in len(graph.node_datas):
		var rel_pos: Vector2 = graph.get_node_position(i)
		points.append(rel_pos + graph.global_position)
		draw_lines_between_points(points, radius, element)

func clear_outer_area() -> void:
	var width: int = 200
	var height: int = 200
	var border: int = 2
	var wall_offset: int = 0
	var bottom_size: int = 20

	# Clear top border
	powder_instance.clear_sim_area(wall_offset, wall_offset, width - (wall_offset*2), border)
	# Clear bottom border
	#powder_instance.clear_sim_area(wall_offset, height - border - wall_offset, width - (wall_offset*2), border)
	# Clear left border
	powder_instance.clear_sim_area(wall_offset, wall_offset , border, height - (wall_offset*2))
	# Clear right border
	powder_instance.clear_sim_area(width - border - wall_offset, wall_offset, border, height - (wall_offset*2))

func transform_position(pos: Vector2) -> Vector2:
	return (pos-global_position) / scale
