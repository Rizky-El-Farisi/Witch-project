extends CenterContainer


onready var tween = $Tween

var appeared = false

func _ready():
	pass


func appear():
	tween.interpolate_property(self, "rect_position:y", -134, 254, 2, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()


func _on_BtnRevive_pressed() -> void:
	Transition.change_scene("res://Lv1.tscn")


func _on_Player_hero_death() -> void:
	if not appeared:
		appeared = true
		appear()


func _on_exit_pressed() -> void:
	Transition.change_scene("res://Assets/title.tscn")
