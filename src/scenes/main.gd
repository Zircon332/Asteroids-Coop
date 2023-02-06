extends Node2D


enum GAME_STATES {START, PLAY, END}

const shipScene := preload("res://entities/ship/ship.tscn")

onready var hud := $CanvasLayer/HUD
onready var start_screen := $CanvasLayer/StartScreen
onready var end_screen := $CanvasLayer/EndScreen
onready var spawner := $Spawner

var player_count := 1
var game_state := 0
var points := 0
var wave := 0


func _input(event) -> void:
	match game_state:
		GAME_STATES.START:
			if Input.is_action_just_pressed("ui_accept"):
				start_game()
				
			if Input.is_action_just_pressed("shoot_2"):
				toggle_player_two()
		
		GAME_STATES.PLAY:
			if Input.is_action_just_pressed("ui_cancel"):
				var players = get_tree().get_nodes_in_group("players")
				for p in players:
					p.hurt()
		
		GAME_STATES.END:
			if Input.is_action_just_pressed("ui_accept"):
				reset_game()


func start_game() -> void:
	start_screen.visible = false
	end_screen.visible = false
	game_state = GAME_STATES.PLAY
	spawner.spawn_pack()
	spawn_players()


func reset_game() -> void:
	game_state = GAME_STATES.START
	points = 0
	wave = 0
	
	var players = get_tree().get_nodes_in_group("players")
	for p in players:
		p.queue_free()
	
	var asteroids = get_tree().get_nodes_in_group("asteroids")
	for a in asteroids:
		a.queue_free()
	
	start_screen.visible = true
	end_screen.visible = false
	hud.display_point(0)


func toggle_player_two():
	if player_count == 1:
		player_count = 2
	else:
		player_count = 1
	
	start_screen.set_coins(player_count)


func spawn_players() -> void:
	for i in range(player_count):
		var ship = shipScene.instance()
		ship.global_position = get_viewport_rect().size / 2 + Vector2.RIGHT * i * 50
		ship.set_player_id(i + 1)
		add_child(ship)


func _physics_process(delta) -> void:
	if game_state == GAME_STATES.PLAY:
		if _is_all_players_dead():
			game_state = GAME_STATES.END
			end_screen.visible = true
		
		var asteroids = get_tree().get_nodes_in_group("asteroids")
		if asteroids.size() == 0:
				wave += 1
				spawner.spawn_pack(wave + 4)


func _on_Asteroid_destroyed(size: int):
	add_point(size * -20 + 80)


func _is_all_players_dead() -> bool:
	var players = get_tree().get_nodes_in_group("players")
	var is_all_dead = true
	for p in players:
		is_all_dead = is_all_dead && p.is_dead
	
	return is_all_dead


func add_point(point):
	points += point
	hud.display_point(points)
