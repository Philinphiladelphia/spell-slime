extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalInventory.contents_changed.connect(process_items)
	process_items()

func process_items():
	for child in %item_display.get_children():
		child.queue_free()
	
	for item in GlobalInventory.get_items():
		var item_rect: TextureRect = TextureRect.new()
		item_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		item_rect.texture = load(item.get_property("image"))
		%item_display.add_child(item_rect)
	
