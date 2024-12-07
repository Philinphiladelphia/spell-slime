extends Node

var item_queue = []

func add_item_to_queue(item):
	item_queue.append(item)
	# Apply item effects globally if needed
