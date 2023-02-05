extends Node
class_name ScreenWrapper


func wrap(node: Node2D, viewport: Viewport) -> void:
	var rect := viewport.get_visible_rect()
	var position = node.global_position
	
	if position.x < rect.position.x:
		position.x = rect.end.x
	if position.x > rect.end.x:
		position.x = rect.position.x
	if position.y < rect.position.y:
		position.y = rect.end.y
	if position.y > rect.end.y:
		position.y = rect.position.y
	
	node.global_position = position
