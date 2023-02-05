extends Control


onready var start_label := $"%StartLabel"


func _on_FlashTimer_timeout():
	start_label.visible = !start_label.visible
