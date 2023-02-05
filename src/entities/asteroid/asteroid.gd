extends Area2D


signal destroyed(size)

export(int) var speed := 100
export(float) var spread := 30

var direction := Vector2.UP
var size := 3

onready var context := get_parent()

onready var _model := $Polygon2D
onready var _collision_shape := $CollisionShape2D
onready var _screen_wrapper := $ScreenWrapper


func _ready():
	if context.has_method("_on_Asteroid_destroyed"):
		connect("destroyed", context, "_on_Asteroid_destroyed")
	
	_model.scale = Vector2(size, size)
	_collision_shape.shape.radius = _collision_shape.shape.radius * size


func _physics_process(delta) -> void:
	position += delta * speed * direction


func spawn() -> void:
	var center_offset := 50
	var target := Vector2(
		rand_range(center_offset, get_viewport_rect().size.x - center_offset),
		rand_range(center_offset, get_viewport_rect().size.y - center_offset)
	)
	
	direction = position.direction_to(target)


func hurt() -> void:
	if size > 1:
		# Can't preload, so this was the next best thing
		var scene: PackedScene = load("res://entities/asteroid/asteroid.tscn")
		for offset in [-spread, spread]:
			var child := scene.instance()
			var angle: float = direction.angle() + deg2rad(offset)
			child.global_position = global_position
			child.direction = Vector2.RIGHT.rotated(angle)
			child.size = size - 1
			
			context.call_deferred("add_child", child)
	
	emit_signal("destroyed", size)
	queue_free()


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	_screen_wrapper.wrap(self, viewport)


func _on_Asteroid_body_entered(body: KinematicBody2D):
	if body.has_method("hurt"):
		body.hurt()
	
	hurt()
