extends KinematicBody2D


export(int) var max_speed := 300
export(int) var acceleration := 300
export(float) var friction := 0.001
export(float) var rotation_speed := 3.0

var velocity := Vector2()
var rotation_dir := 0

var _is_thrusting := false


func _physics_process(delta: float) -> void:
	get_input()
	
	rotation += rotation_dir * rotation_speed * delta
	_calculate_velocity(delta)
	
	velocity = move_and_slide(velocity)


func get_input() -> void:
	rotation_dir = 0
	
	if Input.is_action_pressed("rotate_right"):
		rotation_dir += 1
	if Input.is_action_pressed("rotate_left"):
		rotation_dir -= 1
	
	_is_thrusting = Input.is_action_pressed("thrust")


func _calculate_velocity(delta: float) -> void:
	if _is_thrusting:
		velocity += Vector2(acceleration * delta, 0.0).rotated(rotation)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	
	velocity = velocity.limit_length(max_speed)