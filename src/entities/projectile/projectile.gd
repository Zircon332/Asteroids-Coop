extends Area2D


export(int) var speed := 300


func _physics_process(delta: float) -> void:
	position += Vector2(speed * delta, 0.0).rotated(rotation)


func _on_Projectile_body_entered(body: KinematicBody2D):
	if body.has_method("hurt"):
		body.hurt()
	
	queue_free()
		
