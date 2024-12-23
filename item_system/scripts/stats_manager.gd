extends Node

var temp_stats: Dictionary = {}

@export var temp_stats_file_path: String = "res://savedata/tower_stats/temp_stats.json"

var non_stat_keys: Array = ["name", "description", "image"]

func apply_item_effects(item) -> void:
	for key in item.properties:
		var value = item.get_property(key)
		if value != null and key not in non_stat_keys:
			if temp_stats.has(key):
				temp_stats[key] += value
			else:
				temp_stats[key] = value

	save_temp_stats()

func save_temp_stats() -> void:
	var file: FileAccess = FileAccess.open(temp_stats_file_path, FileAccess.WRITE)
	if file:
		var json_string: String = JSON.stringify(temp_stats, "\t")
		file.store_string(json_string)
		file.close()

func display_item_properties(item) -> void:
	var name = item.get_property("name", "Unknown")
	var description = item.get_property("description", "No description")

	print("Name: ", name)
	print("Description: ", description)

	for key in item.properties:
		var value = item.get_property(key)
		if value != null:
			print(key.capitalize().replace("_", " "), ": ", value)
