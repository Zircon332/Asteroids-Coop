extends Control


onready var _score := $MarginContainer/Score


func set_score(val: int) -> void:
	_score.text = str(val)
