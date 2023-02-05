extends KinematicBody2D


var dir := Vector2.ZERO
export var speed := 100


func _ready():
	spawn()


func spawn():
	dir = Vector2(randf(), randf())


func _physics_process(delta) -> void:
	position += delta * speed * dir
