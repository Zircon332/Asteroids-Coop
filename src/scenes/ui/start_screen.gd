extends Control


onready var start_label := $"%StartLabel"
onready var coin_label := $"%CoinLabel"


func set_coins(count) -> void:
	coin_label.text = "%d coin %d play" % [count, count]


func _on_FlashTimer_timeout():
	start_label.visible = !start_label.visible
