extends KinematicBody2D
class_name Ship


const ProjectileScene := preload("res://entities/projectile/projectile.tscn")

export(int) var max_speed := 300
export(int) var acceleration := 300
export(float) var friction := 0.001
export(float) var rotation_speed := 3.0

var velocity := Vector2()
var rotation_dir := 0

var _is_thrusting := false

onready var context := get_parent()

onready var _tip := $Tip


func _physics_process(delta: float) -> void:
	_get_input()
	
	rotation += rotation_dir * rotation_speed * delta
	_calculate_velocity(delta)
	
	velocity = move_and_slide(velocity)


func hurt() -> void:
	queue_free()


func shoot() -> void:
	var projectile: Projectile = ProjectileScene.instance()
	context.add_child(projectile)
	projectile.setup({
		"position": _tip.global_position,
		"rotation": global_rotation,
		"target_layer": Enums.PhysicsLayer.SAUCER,
		"speed": velocity.length(),
	})

func _get_input() -> void:
	rotation_dir = 0
	
	if Input.is_action_pressed("rotate_right"):
		rotation_dir += 1
	if Input.is_action_pressed("rotate_left"):
		rotation_dir -= 1
		
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	_is_thrusting = Input.is_action_pressed("thrust")


func _calculate_velocity(delta: float) -> void:
	if _is_thrusting:
		velocity += Vector2(acceleration * delta, 0.0).rotated(rotation)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	
	velocity = velocity.limit_length(max_speed)
