extends PowderToyGodot

# this controls simulation speed
var sim_speed: float = 60.0 # fps
var accumulated_fractional_frame: float = 0.0

# Define configurable display scale
var display_scale: float = 1

var draw_rect_size_boost: float = 0.1

# Buffer for powder manifestation requests
var powder_manifestation_buffer: Array = []

# Dictionary to store colors for each particle type
var particle_colors: Dictionary = {}

# Path to the JSON file
var colors_file_path: String = "res://addons/powder_toy_godot/colors.json"

var background_transparency: float = 0

var base_powder_arrays: Array
var powder_array : ArrayMesh
var powder_mesh : MeshInstance2D

# my workstation is way weaker than most of the gpus that I'll be running this game on. 
# I shouldn't optimize too far towards my own requirements
# I still wanna cut powder toy to 80 tho

# a rectangle is made out of two triangles

# at the end of the day, this is just sampling resolution.
# we will only sample the array we have up to the specified extent.

# next step is to make a little drawing. Perhaps I'll let the players
# thicken the lines

func _ready() -> void:
	# Load colors from the JSON file
	load_colors()
	
	# Initialize the ArrayMesh
	powder_array = ArrayMesh.new()
	base_powder_arrays = []
	base_powder_arrays.resize(Mesh.ARRAY_MAX)
	
	powder_mesh = MeshInstance2D.new()
	add_child(powder_mesh)

var accumulated_time: float = 0.0

func _process(delta: float) -> void:
	accumulated_time += delta * sim_speed

	while accumulated_time >= 1.0:
		run_powder_toy_frame()
		accumulated_time -= 1.0
	
	get_particles_from_powder_toy()
	#get_walls_from_powder_toy()
	queue_redraw()

func count_element(type: int) -> int:
	var count: int = 0
	var type_array: Array = get_particle_type_array()
	for y: int in range(type_array.size()):
		for x: int in range(type_array[y].size()):
			var type_num: int = type_array[y][x]
			if (type == type_num):
				count += 1
	return count


func _draw() -> void:
	var type_array: Array = get_particle_type_array()
	#var wall_array: Array = get_wall_type_array()

	# Create a PackedVector2Array for 2D vertices
	var vertices: PackedVector2Array = PackedVector2Array()
	var colors: PackedColorArray = PackedColorArray()

	for y: int in range(type_array.size()):
		for x: int in range(type_array[y].size()):
			var particle_type: int = type_array[y][x]
			var color: Color = get_color_from_index(particle_type)

			# Calculate the vertices for the two triangles forming the rectangle
			var v0: Vector2 = Vector2(x * display_scale, y * display_scale)
			var v1: Vector2 = Vector2((x + 1) * display_scale, y * display_scale)
			var v2: Vector2 = Vector2(x * display_scale, (y + 1) * display_scale)
			var v3: Vector2 = Vector2((x + 1) * display_scale, (y + 1) * display_scale)

			# First triangle (v0, v1, v2)
			vertices.push_back(v0)
			vertices.push_back(v1)
			vertices.push_back(v2)
			colors.push_back(color)
			colors.push_back(color)
			colors.push_back(color)

			# Second triangle (v1, v2, v3)
			vertices.push_back(v1)
			vertices.push_back(v2)
			vertices.push_back(v3)
			colors.push_back(color)
			colors.push_back(color)
			colors.push_back(color)

	base_powder_arrays[Mesh.ARRAY_VERTEX] = vertices
	base_powder_arrays[Mesh.ARRAY_COLOR] = colors

	powder_array.clear_surfaces()
	# Create the Mesh with PRIMITIVE_TRIANGLES
	powder_array.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, base_powder_arrays)
	# Create a MeshInstance2D and assign the mesh

	powder_mesh.mesh = powder_array

func get_wall_color_from_index(index: int) -> Color:
	# Define wall colors based on index
	match index:
		1:
			return Color(1, 1, 1) # Example: white for wall type 1
		2:
			return Color(0.5, 0.5, 0.5) # Example: grey for wall type 2
		# Add more wall types and colors as needed
		_:
			return Color(0, 0, 0) # Default color for unknown wall types

func get_color_from_index(index: int) -> Color:
	if index == 0:
		return Color(0, 0, 0, background_transparency) # Transparent
	if not particle_colors.has(index):
		# Assign a random color if not found
		particle_colors[index] = Color(randf(), randf(), randf(), 1)
		#save_colors()
	return particle_colors[index]

func load_colors() -> void:
	var file: FileAccess = FileAccess.open(colors_file_path, FileAccess.READ)
	if file:
		var json: JSON = JSON.new()
		var file_text: String = file.get_as_text()
		json.parse(file_text)
		var data: Dictionary = json.data
		for key: String in data.keys():
			particle_colors[int(key)] = str_to_var(data[key])
		file.close()

#func save_colors() -> void:
	#var file: FileAccess = FileAccess.open(colors_file_path, FileAccess.WRITE)
	#if file:
		#var data: Dictionary = {}
		#for key: String in particle_colors.keys():
			#data[str(key)] = var_to_str(particle_colors[key])
		#var json_string: String = JSON.stringify(data, "\t")
		#file.store_string(json_string)
		#file.close()

# I need powder lines
