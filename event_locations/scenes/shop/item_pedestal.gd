extends Sprite2D

var buttonsound = "reward_button"
var item: InventoryItem
@onready var light: PointLight2D = $item_sprite/PointLight2D

@export var has_cost: bool = false
var cost: int = 0

#next steps:
# make pedestals with cost
# make slimes drop crystals that suck into the player
# make different pedestals for spells, movement, and passive upgrades
# visualize the inventory as a list of items at the bottom or top of the screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# GlobalInventory.add_item(selected_items[0])
	# SoundManager.play_sfx(buttonsound, 0, -6, 1)
	item = ItemUtils.select_random_item()
	
	$item_sprite.texture = load(item.get_property("image"))
	#
	## display attributes
	#var current_button: Button = buttons[selected_items.size()-1]
	#current_button.icon = item_texture
	var item_name: String = item.get_property("name").capitalize()
	var item_description: String = item.get_property("description")
	
	light.color = ItemUtils.item_colors[item.get_property("rarity")]
	
	if has_cost:
		cost = item.get_property("cost")
		%cost_label.text = str(cost)
	else:
		%cost_label.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_input_glyph_activated() -> void:
	if has_cost:
		if PlayerState.crystals < cost:
			var label = GunUtils.hit_marker_scene.instantiate()
			label.text = "not enough crystals"
			label.global_position = global_position + Vector2(-80, -20)
			get_tree().root.add_child(label)
			return
		else:
			PlayerState.crystals -= cost
	
	SoundManager.play_sfx(buttonsound, 0, -6, 1)
	GlobalInventory.add_item(item)
	
	for child in get_children():
		child.queue_free()
