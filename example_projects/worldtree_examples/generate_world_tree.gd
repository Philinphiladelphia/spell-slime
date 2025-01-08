extends Node

enum NodeType { FIGHT, DIFFICULT_FIGHT, TREASURE, MYSTERY, BOSS }

class TreeNode:
	var type: NodeType
	var connections: Array
	var tier: int

	func _init(_type: NodeType, _tier: int):
		type = _type
		connections = []
		tier = _tier

var tree = []

func generate_tree(depth: int, max_width: int, total_nodes: int) -> Array:
	var nodes = []
	var node_count = 0

	# Create nodes and assign types for earlier tiers
	for i in range(total_nodes - 3):
		var node_type = NodeType.FIGHT
		if i % 5 == 0:
			node_type = NodeType.DIFFICULT_FIGHT
		elif i % 3 == 0:
			node_type = NodeType.TREASURE
		elif i % 2 == 0:
			node_type = NodeType.MYSTERY
		var tier = int(i / max_width)
		var node = TreeNode.new(node_type, tier)
		nodes.append(node)
		node_count += 1

	# Add exactly two nodes for the final tier
	var final_tier = depth - 1
	for i in range(2):
		var node_type = NodeType.BOSS if i == 1 else NodeType.FIGHT
		var node = TreeNode.new(node_type, final_tier)
		nodes.append(node)
		node_count += 1

	# Connect nodes ensuring each node connects to 1-3 nodes in the next tier
	for i in range(depth - 1):
		var tier_start = int(i * max_width)
		var tier_end = int((i + 1) * max_width)
		for j in range(tier_start, min(tier_end, node_count)):
			var connections = randi() % 3 + 1
			for k in range(connections):
				var next_tier_index = tier_end + k
				if next_tier_index < node_count:
					nodes[j].connections.append(nodes[next_tier_index])

	return nodes

func _ready():
	tree = generate_tree(5, 3, 15)
	for node in tree:
		print("Node Type: ", node.type, " Tier: ", node.tier, " Connections: ", node.connections.size())
