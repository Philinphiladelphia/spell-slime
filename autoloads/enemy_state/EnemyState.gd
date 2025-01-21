class_name EnemyStateTracker
extends Node

var colors_file_path: String = "res://addons/powder_toy_godot/colors.json"
const uuid_util = preload('res://addons/uuid/uuid.gd')

var slime_colors: Dictionary = {}

func _ready() -> void:
	load_colors()

func load_colors() -> void:
	var file: FileAccess = FileAccess.open(colors_file_path, FileAccess.READ)
	if file:
		var json: JSON = JSON.new()
		var file_text: String = file.get_as_text()
		json.parse(file_text)
		var data: Dictionary = json.data
		for key: String in data.keys():
			slime_colors[int(key)] = str_to_var(data[key])
		file.close()

func add_enemy_to_state(enemy: EnemyController):
	var enemy_uuid = uuid_util.v4()
	enemies[enemy_uuid] = enemy
	return enemy_uuid

func remove_enemy_from_state(uuid):
	enemies.erase(uuid)
	
func get_enemy_locations() -> Array[Vector2]:
	var locations: Array[Vector2]
	for uuid in enemies.keys():
		var enemy: EnemyController = enemies[uuid]
		locations.append(enemy.slime_position)
		
	return locations
	
# maps enemy id to 
var enemies: Dictionary
