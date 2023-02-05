extends KinematicBody2D


var dir := Vector2.ZERO
export var speed := 100


func _ready() -> void:
	spawn()


func spawn() -> void:
	dir = Vector2(randf(), randf())


func _physics_process(delta) -> void:
	position += delta * speed * dir


func hurt() -> void:
	queue_free()
