extends Node2D



func _on_AnimatedSprite_animation_finished() -> void:
	queue_free()
