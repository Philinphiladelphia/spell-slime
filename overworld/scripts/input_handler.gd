extends Node


@export var worldgraph : WorldmapView
@export var danger_box: ColorRect
@export var player_sprite: Sprite2D

@onready var inactive_node = preload("res://overworld/level_types/inactive.tres")

var current_node_path: NodePath
var current_node: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_node_path = worldgraph.initial_item.get_path()
	current_node = worldgraph.initial_node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_map_node_gui_input(event : InputEvent, path : NodePath, node_in_path : int, resource : WorldmapNodeData):
	#if event is InputEventMouseMotion:
		#tooltip_root.global_position = event.global_position

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			
			pass
			# load game scene
			
			
			#if skilltree.can_activate(path, node_in_path):
				#tooltip_root.hide()
				#skilltree.max_unlock_cost -= skilltree.set_node_state(path, node_in_path, 1)
				#_skillpoints_changed()
#
		#if event.button_index == MOUSE_BUTTON_MIDDLE && event.pressed:
			#skilltree.get_node(path).remove_node(node_in_path)


#func _unhandled_input(event : InputEvent):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_MIDDLE && event.pressed:
			#add_node_index = add_target.add_node(event.position * skilltree.get_global_transform(), add_node_index)


# Preload the scenes
var scene1 = "res://levels/moonswept_fields/day/moonrise_lighting.tscn"
var scene2 = "res://levels/moonswept_fields/night/night_lighting.tscn"

func _on_load_pressed():
	var varr = str_to_var($"Anchors/BottomLeftBox/Box/Box2/SaveData".text)
	if !varr is Array || varr.size() < 2: return
	if !varr[0] is int: return
	if !varr[1] is Dictionary: return

	worldgraph.max_unlock_cost = varr[0]
	worldgraph.load_state(varr[1])

func move_player(path: NodePath, node_in_path: int, global_node_pos: Vector2):
	worldgraph.get_node(path).change_node(current_node, inactive_node) 
	
	current_node_path = path
	current_node = node_in_path
	
	player_sprite.global_position = global_node_pos

func _on_worldmap_view_node_gui_input(event: InputEvent, path: NodePath, node_in_path: int, resource: WorldmapNodeData) -> void:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
				
				# need to add graph coords
				var worldgraph_pos: Vector2 = worldgraph.get_screen_position()
				var global_node_pos: Vector2 = worldgraph.get_node(path).get_node_position(node_in_path) + worldgraph_pos
				
				var danger_rect: Rect2 = danger_box.get_global_rect()
				
				if danger_rect.has_point(global_node_pos):
					print("DANGER")
				else:
					var node_data = worldgraph.get_node_data(path, node_in_path)
					print(node_data.id)
				
				var nodes_adjacent = worldgraph.get_node(path).connection_exists(current_node, node_in_path)
				
				if worldgraph.can_activate(path, node_in_path) and nodes_adjacent:
					#print(worldgraph.get_node_data(path, node_in_path))
					worldgraph.set_node_state(path, node_in_path, 1)
					worldgraph.recalculate_map()
					
					move_player(path, node_in_path, global_node_pos)

				elif worldgraph.get_node_state(path, node_in_path) > 0 and nodes_adjacent:
					move_player(path, node_in_path, global_node_pos)
					
			#		worldgraph.load_state()
					#var selected_scene = scene1 if randf_range(0, 2) < 1 else scene2
			#
					#SoundManager.play_sfx("reward_button", 0, -6, 1)
					#SceneLoader.load_scene(selected_scene)
