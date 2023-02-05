extends KinematicBody2D
class_name Ship


const ProjectileScene := preload("res://entities/projectile/projectile.tscn")

export(int) var max_speed := 300
export(int) var acceleration := 300
export(float) var friction := 0.001
export(float) var rotation_speed := 3.0
export(int) var max_bullet_count := 4
export(float) var bullet_cooldown := 1.0

var velocity := Vector2()
var rotation_dir := 0
var is_dead := false
var player_id = 0

var _is_thrusting := false

onready var context := get_parent()
onready var bullet_count := max_bullet_count

onready var _tip := $Tip
onready var _screen_wrapper := $ScreenWrapper


func _physics_process(delta: float) -> void:
	if not is_dead:
		_get_input()
	
	rotation += rotation_dir * rotation_speed * delta
	_calculate_velocity(delta)
	
	velocity = move_and_slide(velocity)


func hurt() -> void:
	is_dead = true


func shoot() -> void:
	var projectile: Projectile = ProjectileScene.instance()
	context.add_child(projectile)
	
	var dot = velocity.normalized().dot(Vector2.RIGHT.rotated(global_rotation))
	var weight := max(dot, 0.0)
	projectile.setup({
		"position": _tip.global_position,
		"rotation": global_rotation,
		"target_layer": Enums.PhysicsLayer.SAUCER,
		"speed": velocity.length() * weight,
	})
	

func _get_input() -> void:
	rotation_dir = 0
	
	if Input.is_action_pressed("rotate_right_" + str(player_id)):
		rotation_dir += 1
	if Input.is_action_pressed("rotate_left_" + str(player_id)):
		rotation_dir -= 1
		
	if Input.is_action_just_pressed("shoot_" + str(player_id)):
		if bullet_count > 0:
			shoot()
			bullet_count -= 1
			_create_bullet_cooldown_timer()
	
	_is_thrusting = Input.is_action_pressed("thrust_" + str(player_id))


func set_player_id(id) -> void:
	player_id = id


func _calculate_velocity(delta: float) -> void:
	if _is_thrusting:
		velocity += Vector2(acceleration * delta, 0.0).rotated(rotation)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	
	velocity = velocity.limit_length(max_speed)


func _create_bullet_cooldown_timer() -> void:
	var timer = get_tree().create_timer(bullet_cooldown)
	timer.connect("timeout", self, "_on_BulletCooldownTimer_timeout")


func _on_BulletCooldownTimer_timeout() -> void:
	bullet_count += 1


func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport):
	_screen_wrapper.wrap(self, viewport)


func _on_ReviveArea_body_entered(body):
	if body.is_in_group("players") and body != self:
		is_dead = false
