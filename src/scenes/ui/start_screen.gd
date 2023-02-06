extends Control


onready var _start_label := $"%StartLabel"
onready var _coin_label := $"%CoinLabel"


func set_coins(count) -> void:
	_coin_label.text = "%d coin %d play" % [count, count]


func _on_FlashTimer_timeout():
	_start_label.visible = !_start_label.visible
