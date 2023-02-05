extends Node2D


const GAME_STATES := {
	0: "start",
	1: "play",
	2: "end",
}

const shipScene := preload("res://entities/ship/ship.tscn")

onready var hud := $CanvasLayer/HUD
onready var start_screen := $CanvasLayer/StartScreen
onready var end_screen := $CanvasLayer/EndScreen
onready var spawner := $Spawner

export(int) var player_count := 2

var game_state := 0
var points := 0


func _input(event) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		var players = get_tree().get_nodes_in_group("players")
		for p in players:
			p.hurt()

	if game_state != 1:
		if Input.is_action_just_pressed("ui_accept"):
			start_game()


func start_game() -> void:
	start_screen.visible = false
	end_screen.visible = false
	game_state = GAME_STATES.values().find("play")
	spawner.spawn_pack()
	spawn_players()


func spawn_players():
	for i in range(player_count):
		var ship = shipScene.instance()
		ship.global_position = get_viewport_rect().size / 2
		ship.set_player_id(i + 1)
		add_child(ship)


func _physics_process(delta):
	if game_state == 1:
		var players = get_tree().get_nodes_in_group("players")
		if players.size() == 0:
				game_state = GAME_STATES.values().find("end")
				end_screen.visible = true
		
		var asteroids = get_tree().get_nodes_in_group("asteroids")
		if asteroids.size() == 0:
				spawner.spawn_pack()


func _on_Asteroid_destroyed(size: int):
	points += size * -20 + 80
