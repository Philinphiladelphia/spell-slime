extends Node2D

@onready var tileset = $middle/TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply_damage(amount, proj_position):
	pass
	# Convert projectile position to tile position
	#var tile_pos = tileset.world_to_map(proj_position)
	#
	#print(proj_position)
	#print(tile_pos)
#
	## Get the tile ID at the tile position
	#var tile_id = tileset.get_cellv(tile_pos)
	#
	#print("health not found")
#
	## Check if the tile has custom data "health"
	#if tileset.tile_has_custom_data(tile_id):
		#var health = tileset.tile_get_custom_data(tile_id, "health")
		#
		#print(health)
		## Reduce the health value by the damage amount
		#health -= amount
		#
		#print(health)
		#
		## Update the tile's custom data
		#tileset.tile_set_custom_data(tile_id, "health", health)
		#
		## If health is zero or less, remove the tile
		#if health <= 0:
			#tileset.set_cellv(tile_pos, -1)
