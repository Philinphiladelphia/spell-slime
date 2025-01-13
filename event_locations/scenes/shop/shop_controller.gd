extends Node2D

@export var shopkeeper: JumpingSlime

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bodies = shopkeeper.softbody.get_rigid_bodies()
	var centerish_body = bodies[len(bodies)/2].rigidbody
	centerish_body.freeze = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
