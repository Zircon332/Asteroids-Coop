extends Path2D


const asteroidScene := preload("res://entities/asteroid/asteroid.tscn")

onready var context := get_parent() 
onready var _rng := RandomNumberGenerator.new()

onready var _spawn_point := $SpawnPoint


func spawn_pack() -> void:
	var pack_size := 10
	
	for _i in range(pack_size):
		_spawn_point.unit_offset = _rng.randf()
		spawn(_offset_position(_spawn_point.global_position))


func spawn(pos: Vector2) -> void:
	var npc := asteroidScene.instance()
	npc.global_position = pos
	context.add_child(npc)


func _offset_position(pos: Vector2) -> Vector2:
	var angle := _rng.randf_range(-PI, PI)
	var direction := Vector2.RIGHT.rotated(angle)
	var vector := direction * randf()
	print(pos + vector)
	return pos + vector