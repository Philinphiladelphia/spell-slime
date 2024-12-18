extends Control

# @onready var inventory: Inventory = $Inventory
# inventory should be an autoload singleton loaded along with save slot. The complete game state is:
# inventory, world progress, tower health
# these three things make up a run
# that and the random seed used to create the run

# all this stuff should live in the game data I guess
# these things make up a save file. We should have three savefiles.

# to use items, I need an item interpreter that takes key-value pairs from the inventory list
# and applies them to my tower abilities.

var items_selected = 0
var allowable_items = 1

@onready var btn_slot_1: Button = %button1
@onready var btn_slot_2: Button = %button2
@onready var btn_slot_3: Button = %button3

var buttonsound = "reward_button"

var probabilities = {
	"common": 0.5,
	"rare": 0.3,
	"epic": 0.15,
	"legendary": 0.05
}

@onready var buttons = [btn_slot_1, btn_slot_2, btn_slot_3]

var selected_items = []

var round_ending = false

func _process(delta: float) -> void:
	if items_selected >= allowable_items && not round_ending:
		round_ending = true
		$round_end_timer.start()

func _ready() -> void:
	# seed should be
	btn_slot_1.pressed.connect(_on_slot_1_pressed)
	btn_slot_2.pressed.connect(_on_slot_2_pressed)
	btn_slot_3.pressed.connect(_on_slot_3_pressed)
	_select_items_for_slots()

func _select_items_for_slots() -> void:
	selected_items.clear()
	while selected_items.size() < 3:
		var item = _select_random_item()
		if item not in selected_items:
			selected_items.append(item)
			var item_texture = load(selected_items[selected_items.size()-1].get_property("image"))
			buttons[selected_items.size()-1].icon = item_texture

func _select_random_item() -> InventoryItem:
	var rand = randf()
	var cumulative = 0.0
	for rarity in probabilities.keys():
		cumulative += probabilities[rarity]
		if rand < cumulative:
			return _get_random_item_from_pool(rarity)
	return _get_random_item_from_pool("common")

func _get_random_item_from_pool(rarity: String) -> InventoryItem:
	match rarity:
		"common":
			return CommonItems.get_items()[randi() % CommonItems.get_items().size()] 
		"rare":
			return RareItems.get_items()[randi() % RareItems.get_items().size()] 
		"epic":
			return EpicItems.get_items()[randi() % EpicItems.get_items().size()] 
		"legendary":
			return LegendaryItems.get_items()[randi() % LegendaryItems.get_items().size()] 
		_:
			# common again
			return CommonItems.get_items()[randi() % CommonItems.get_items().size()]

func _on_slot_1_pressed() -> void:
	if items_selected >= allowable_items:
		return
	SoundManager.play_sfx(buttonsound, 0, -6, 1)
	GlobalInventory.add_item(selected_items[0])
	for item in GlobalInventory.get_items():
		print(item.get_property("name"))
		
	items_selected += 1

func _on_slot_2_pressed() -> void:
	if items_selected >= allowable_items:
		return
	SoundManager.play_sfx(buttonsound, 0, -6, 1)
	GlobalInventory.add_item(selected_items[1])
	
	items_selected += 1

func _on_slot_3_pressed() -> void:
	if items_selected >= allowable_items:
		return
	SoundManager.play_sfx(buttonsound, 0, -6, 1)
	GlobalInventory.add_item(selected_items[2])
	
	items_selected += 1


func _on_round_end_timer_timeout() -> void:
	SceneLoader.load_scene("res://maaack/scenes/menus/main_menu/main_menu_with_animations.tscn")
