extends RigidBody2D

@export var damage: int  = 10
@export var connection_1: Node2D
@export var connection_2: Node2D

var init: bool = false

func joint_connect(node1: RigidBody2D, node2: RigidBody2D):
	var connection: Joint2D = PinJoint2D.new()
	connection.softness = 2
	get_parent().add_child(connection)
	connection.global_position = node2.global_position
	connection.node_a = connection.get_path_to(node1)
	connection.node_b = connection.get_path_to(node2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not init:
		for body in $Area2D.get_overlapping_bodies():
			joint_connect(self, body)
		init = true
