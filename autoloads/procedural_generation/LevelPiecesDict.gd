class_name LevelPiecesDict
extends Node

# defines block size for each piece
const base_height = 100
const base_width = 100

var spawn_locations: Dictionary = {
	"world1" : "res://levels/level_pieces/resource_descriptors/world1_spawn.tres"
}

var level_pieces: Dictionary = {
	"world1": 
		[
			"res://levels/level_pieces/resource_descriptors/1x1_battle_descriptor.tres",
			"res://levels/level_pieces/resource_descriptors/1x2_battle_descriptor.tres",
			"res://levels/level_pieces/resource_descriptors/2x1_battle_descriptor.tres",
			"res://levels/level_pieces/resource_descriptors/2x2_battle_descriptor.tres"
		]
}
