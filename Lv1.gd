extends Node2D

onready var health_progress = $CanvasLayer/HealthBar/TextureProgress
onready var soul_amount = $CanvasLayer/Soul/Label

func _on_OutZone_body_entered(body: Node) -> void:
	if body.name == 'Player':
		get_tree().change_scene("res://Lv1.tscn")

func _on_Player_soul_update(value):
	soul_amount.text = String(value)
	


func _on_Player_hero_update_health(value) -> void:
	health_progress.value = value


