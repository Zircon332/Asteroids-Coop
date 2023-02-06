extends Control


onready var score_display = $MarginContainer/Score


func display_point(points) -> void:
	score_display.text = str(points).pad_zeros(2)
