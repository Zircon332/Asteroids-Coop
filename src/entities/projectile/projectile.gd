extends Area2D
class_name Projectile


export(int) var speed := 300


func setup(pos: Vector2, rot: float, target_layer: int) -> void:
	global_position = pos
	global_rotation = rot
	set_collision_mask_bit(target_layer, true)


func _physics_process(delta: float) -> void:
	position += Vector2(speed * delta, 0.0).rotated(rotation)


func _on_Projectile_body_entered(body: KinematicBody2D):
	if body.has_method("hurt"):
		body.hurt()
	
	queue_free()
		
