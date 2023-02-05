extends Area2D
class_name Projectile


export(int) var speed := 300

onready var _screen_wrapper := $ScreenWrapper


# Params:
# - position: Vector2 | Initial position
# - rotation: float | Facing direction
# - speed: int | Additional addon speed
# - target_layer: int | Collision layer bit for entity that will be hit
func setup(params: Dictionary) -> void:
	global_position = params["position"]
	global_rotation = params["rotation"]
	speed += params["speed"]
	set_collision_mask_bit(params["target_layer"], true)


func _physics_process(delta: float) -> void:
	position += Vector2(speed * delta, 0.0).rotated(rotation)


func _on_Projectile_body_entered(body: KinematicBody2D):
	if body.has_method("hurt"):
		body.hurt()
	
	queue_free()


func _on_DespawnTimer_timeout():
	queue_free()


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	_screen_wrapper.wrap(self, viewport)
