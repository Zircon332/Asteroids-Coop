extends Node2D

const GAME_STATES := {
	0: "start",
	1: "play",
	2: "end",
}


onready var hud := $CanvasLayer/HUD
onready var start_screen := $CanvasLayer/StartScreen
onready var spawner := $Spawner


var game_state := 0
var points := 0


func _ready() -> void:
	pass # Replace with function body.


func _input(event) -> void:
	if game_state == 0:
		if Input.is_action_just_pressed("ui_accept"):
			start_game()


func start_game() -> void:
	start_screen.visible = false
	game_state = GAME_STATES.values().find("play")
	spawner.spawn_pack()
