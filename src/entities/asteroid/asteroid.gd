extends KinematicBody2D


var dir := Vector2.ZERO
export var speed := 100

onready var _screen_wrapper := $ScreenWrapper


func _ready():
	spawn()


func spawn():
	dir = Vector2(randf(), randf())


func _physics_process(delta) -> void:
	position += delta * speed * dir


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	_screen_wrapper.wrap(self, viewport)
