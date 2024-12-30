extends Node


@export var worldgraph : WorldmapView
@export var danger_box: ColorRect
@export var player_sprite: Node2D

@onready var inactive_node = preload("res://overworld/level_types/inactive.tres")

var current_node_path: NodePath
var current_node: int

var player_tween: Tween

var input_disabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# load map state along with current node
	
	current_node_path = worldgraph.initial_item.get_path()
	current_node = worldgraph.initial_node
	
	# need to add graph coords
	var worldgraph_pos: Vector2 = worldgraph.get_screen_position()
	var global_node_pos: Vector2 = worldgraph.get_node(current_node_path).get_node_position(current_node) + worldgraph_pos
	
	player_sprite.global_position = global_node_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	input_disabled = true
	worldgraph.get_node(path).change_node(current_node, inactive_node) 
	
	current_node_path = path
	current_node = node_in_path
	
	player_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
	#player_tween.tween_property($Sprite, "modulate", Color.RED, 1)
	#player_tween.tween_property($Sprite, "scale", Vector2(), 1)
	#player_tween.tween_callback($Sprite.queue_free)
	#
	# Animate the player's movement
	player_tween.tween_property(player_sprite, "global_position", global_node_pos, 2)
	player_tween.finished.connect(visit_graph_node)

func visit_graph_node():
	var node_data = worldgraph.get_node_data(current_node_path, current_node)
	var scene = node_data.data[0]
	SceneLoader._loaded_resource = scene
	#SceneLoader.load_scene(scenepath)
	#print(scenepath)
	
	#var selected_scene = scene1 if randf_range(0, 2) < 1 else scene2
	SceneLoader.change_scene_to_resource()
	input_disabled = false

func _on_worldmap_view_node_gui_input(event: InputEvent, path: NodePath, node_in_path: int, resource: WorldmapNodeData) -> void:
	
		if input_disabled:
			return
	
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
				
				# need to add graph coords
				var worldgraph_pos: Vector2 = worldgraph.get_screen_position()
				var global_node_pos: Vector2 = worldgraph.get_node(path).get_node_position(node_in_path) + worldgraph_pos
				
				var danger_rect: Rect2 = danger_box.get_global_rect()
				
				if danger_rect.has_point(global_node_pos):
					print("DANGER")
				else:
					pass
				
				var nodes_adjacent = worldgraph.get_node(path).connection_exists(current_node, node_in_path)
				var is_active = worldgraph.get_node_state(path, node_in_path) > 0 
				var can_activate = worldgraph.can_activate(path, node_in_path)
				
				if (can_activate or is_active) and nodes_adjacent:
					#print(worldgraph.get_node_data(path, node_in_path))
					worldgraph.set_node_state(path, node_in_path, 1)
					worldgraph.recalculate_map()
					
					# save new map state here
								#		worldgraph.load_state()
					
					move_player(path, node_in_path, global_node_pos)
					
					SoundManager.play_sfx("reward_button", 0, -6, 1)
