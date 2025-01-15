class_name ItemUtilities
extends Node

var probabilities = {
	"common": 0.5,
	"rare": 0.3,
	"epic": 0.15,
	"legendary": 0.05
}

var item_colors = {
	"common": Color(1,1,1),
	"rare": Color(0.439,0.474,0.909),
	"epic": Color(0.859, 0.817, 0.213),
	"legendary": Color(0.93, 0.483, 0.121)
}

var inventory_types = {
	"common": CommonItems,
	"rare": RareItems,
	"epic": EpicItems,
	"legendary": LegendaryItems
}

var default_item: InventoryItem = preload("res://autoloads/item_system/default_item.tscn").instantiate()

func select_random_item() -> InventoryItem:
	var rand = randf()
	var cumulative = 0.0
	for rarity in probabilities.keys():
		cumulative += probabilities[rarity]
		if rand < cumulative:
			return get_random_item_from_pool(rarity)
	return get_random_item_from_pool("common")

func get_random_item_from_pool(rarity: String) -> InventoryItem:
	var inventory_type = inventory_types[rarity]
	
	if inventory_type.get_items().size() > 0:
		var item: InventoryItem = inventory_type.get_items()[randi() % inventory_type.get_items().size()] 
		inventory_type.remove_item(item)
		return item

	return default_item
