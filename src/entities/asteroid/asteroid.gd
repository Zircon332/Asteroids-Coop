extends KinematicBody2D


var direction := Vector2.UP
export var speed := 50
var size := 2

func _ready() -> void:
	spawn()


func spawn() -> void:
	var center_offset = 50
	var target = Vector2(
		rand_range(center_offset, get_viewport_rect().size.x - center_offset),
		rand_range(center_offset, get_viewport_rect().size.y - center_offset)
	)
	
	direction = position.direction_to(target)


func _physics_process(delta) -> void:
	position += delta * speed * direction


func hurt() -> void:
	queue_free()
