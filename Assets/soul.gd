extends Area2D



func _on_Flame_body_entered(body: Node) -> void:
	var _explosion = preload("res://Assets/explosion.tscn")
	var explosion = _explosion.instance()
	explosion.transform = self.transform
	get_tree().current_scene.add_child(explosion)
	
	remove_from_group("lvsoul")
	if body.name == 'Player':
		body.get_soul()
	
	queue_free()
