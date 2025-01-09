extends Node2D


func fire_projectile(projectile_scene: PackedScene, firing_position: Vector2, damage: int, rot: float, velocity: float, max_lifespan: float, post_hit_lifespan: float, mass: float, gun_shake : float) -> void:
	var node_to_fire: Node = projectile_scene.instantiate()
	
	node_to_fire.damage = damage
	node_to_fire.max_projectile_lifespan = max_lifespan
	node_to_fire.projectile_mass = mass
	node_to_fire.post_hit_lifespan = post_hit_lifespan
	
	node_to_fire.global_position = firing_position
	node_to_fire.rotation = rot
	
	var random_addition: float = (((randi() % 100) - 50) / 100.0) * gun_shake
	var direction: Vector2 = Vector2.RIGHT.rotated(rot)
	node_to_fire.apply_impulse(direction * velocity)
	
	get_tree().root.add_child(node_to_fire)
