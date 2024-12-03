extends Node2D

var shaders = {
	"clear": load("res://Shaders/shader_scenes/clear.tscn"),
	"rainbow": load("res://Shaders/shader_scenes/rainbow.tscn"),
	"color_glow": load("res://Shaders/shader_scenes/color_glow.tscn"),
	"shine": load("res://Shaders/shader_scenes/shine.tscn"),
	"gameboy": load("res://Shaders/shader_scenes/gameboy.tscn"),
	"pixelate": load("res://Shaders/shader_scenes/pixelate.tscn"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton && event.pressed:
		var slime = spawn_slime("res://Scenes/slimes/med_slime.tscn", [""], get_viewport().get_mouse_position())
		add_child(slime)
	elif event is InputEventMouseMotion:
		pass

	# Print the size of the viewport.
	# print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)
	
func spawn_slime(scene_path: String, shader_names: Array, position: Vector2):
	var slime_scene = load(scene_path)
	var slime = slime_scene.instantiate()
	slime.position = position
	
		# Apply new shaders in sequence with BackBufferCopy
	var current_node = slime
	for shader_name in shader_names:
		if shaders.has(shader_name):
			var back_buffer_copy = BackBufferCopy.new()
			back_buffer_copy.rect = Rect2(Vector2.ZERO, get_viewport().size)
			add_child(back_buffer_copy)
			
			var new_shader = shaders[shader_name].instantiate()
			new_shader.add_child(current_node)
			back_buffer_copy.add_child(new_shader)
			
			current_node = new_shader
	
	return current_node
