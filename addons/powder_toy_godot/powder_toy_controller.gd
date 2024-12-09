extends Node2D

@onready var powder_toy = %PowderToyGodot
var current_x = 0.0
var ratio = 650.0/200.0
var is_drawing = false
var mouse_pos = Vector2()
var is_right_click = false

var health_element = 17
var health_element_count = 0

var clear_edges_timer : Timer

# while the spellward is active, slime hits deal greatly reduced damage to the tower.

func _ready() -> void:
	powder_toy.sim_speed = 2.0
	powder_toy.set_edge_mode(0)
	powder_toy.set_grav_mode(0)
	
	#powder_toy.wall(80,80,15,1)
	#powder_toy.wall_line(10, 80, 150, 80, 5, 129)
	
	#powder_toy.wall_box(5,5,150,150, 1)

	#powder_toy.flood_powder(80, 65, 2, 0)
	#circle(Vector2(80,80), 20, 114)


	# Add a Timer node and set it to call the clear_outer_area function every 5 seconds
	clear_edges_timer = Timer.new()
	clear_edges_timer.wait_time = 0.05
	add_child(clear_edges_timer)
	clear_edges_timer.connect("timeout", clear_outer_area)
	clear_edges_timer.start()
	
func get_health():
	return powder_toy.count_element(health_element)


func _physics_process(delta: float) -> void:
	pass
	#circle(Vector2(60,110), 5, 4)
	#print(get_health())
	#polygon(Vector2(80,80), 10.0, 8, 1, 4)
	# drawing codes
	#if is_drawing:
		#if is_right_click:
			## 21 is acid
			#powder_toy.powder_circle(mouse_pos.x / ratio, mouse_pos.y / ratio, 5, 87) # Different element
		#else:
			#powder_toy.powder_circle(mouse_pos.x / ratio, mouse_pos.y / ratio, 1, 2) # Different element

func circle(pos: Vector2, radius: float, element: int):
	powder_toy.powder_circle(pos.x, pos.y, radius, element)

func rectangle(top_left: Vector2, width: float, height: float, thickness: float, element: int) -> void:
	var bottom_right = top_left + Vector2(width, height)
	powder_toy.powder_line(top_left.x, top_left.y, bottom_right.x, top_left.y, thickness, element)
	powder_toy.powder_line(bottom_right.x, top_left.y, bottom_right.x, bottom_right.y, thickness, element)
	powder_toy.powder_line(bottom_right.x, bottom_right.y, top_left.x, bottom_right.y, thickness, element)
	powder_toy.powder_line(top_left.x, bottom_right.y, top_left.x, top_left.y, thickness, element)

func square(top_left: Vector2, size: float, thickness: float, element: int) -> void:
	rectangle(top_left, size, size, thickness, element)

func triangle(p1: Vector2, p2: Vector2, p3: Vector2, thickness: float, element: int) -> void:
	powder_toy.powder_line(p1.x, p1.y, p2.x, p2.y, thickness, element)
	powder_toy.powder_line(p2.x, p2.y, p3.x, p3.y, thickness, element)
	powder_toy.powder_line(p3.x, p3.y, p1.x, p1.y, thickness, element)

func polygon(center: Vector2, radius: float, sides: int, thickness: float, element: int) -> void:
	if sides < 3:
		return # A polygon must have at least 3 sides

	var angle_step = 2 * PI / sides
	var points = []

	for i in range(sides):
		var angle = i * angle_step
		var x = center.x + radius * cos(angle)
		var y = center.y + radius * sin(angle)
		points.append(Vector2(x, y))

	for i in range(sides):
		var start = points[i]
		var end = points[(i + 1) % sides]
		powder_toy.powder_line(start.x, start.y, end.x, end.y, thickness, element)

func line(start: Vector2, end: Vector2, thickness: float, element: int) -> void:
	powder_toy.powder_line(start.x, start.y, end.x, end.y, thickness, element)

func _input(event):
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

# this function makes it possible for the powder toy to have void edges while maintaining air pressure.
func clear_outer_area() -> void:
	var width = 120
	var height = 120
	var border = 1
	var wall_offset = 0
	var bottom_size = 20

	# Clear top border
	
	powder_toy.clear_sim_area(wall_offset, wall_offset + bottom_size, width - (wall_offset*2), border)
	# Clear bottom border
	#powder_toy.clear_sim_area(wall_offset, height - border - wall_offset, width - (wall_offset*2), border)
	# Clear left border
	powder_toy.clear_sim_area(wall_offset, wall_offset + bottom_size, border, height - (wall_offset*2))
	# Clear right border
	powder_toy.clear_sim_area(width - border - wall_offset, wall_offset, border, height - (wall_offset*2))
