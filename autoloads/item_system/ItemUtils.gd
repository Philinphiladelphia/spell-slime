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

func select_random_item() -> InventoryItem:
	var rand = randf()
	var cumulative = 0.0
	for rarity in probabilities.keys():
		cumulative += probabilities[rarity]
		if rand < cumulative:
			return get_random_item_from_pool(rarity)
	return get_random_item_from_pool("common")

func get_random_item_from_pool(rarity: String) -> InventoryItem:
	match rarity:
		"common":
			if CommonItems.get_items().size() > 0:
				return CommonItems.get_items()[randi() % CommonItems.get_items().size()] 
		"rare":
			if RareItems.get_items().size() > 0:
				return RareItems.get_items()[randi() % RareItems.get_items().size()]
		"epic":
			if EpicItems.get_items().size() > 0:
				return EpicItems.get_items()[randi() % EpicItems.get_items().size()] 
		"legendary":
			if LegendaryItems.get_items().size() > 0:
				return LegendaryItems.get_items()[randi() % LegendaryItems.get_items().size()] 

	# default, common again
	return CommonItems.get_item_by_id("item1")
