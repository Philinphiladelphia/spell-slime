extends Control

var colors = {}

var colors_file_path = "res://addons/powder_toy_godot/colors.json"

func _ready():
	load_colors()
	display_colors()

func load_colors() -> void:
	var file = FileAccess.open(colors_file_path, FileAccess.READ)
	if file:
		var json = JSON.new()
		var file_text = file.get_as_text()
		json.parse(file_text)
		var data = json.data
		for key in data.keys():
			colors[int(key)] = str_to_var(data[key])
		file.close()


func display_colors():
	var grid = $GridContainer
	for key in colors.keys():
		var color = colors[key]
		var color_rect = ColorRect.new()
		color_rect.size_flags_horizontal = Control.SIZE_EXPAND
		color_rect.size_flags_vertical = Control.SIZE_EXPAND
		color_rect.color = color
		grid.add_child(color_rect)
