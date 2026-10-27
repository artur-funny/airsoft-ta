extends Control

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file(Scenes.select_level(1))

func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file(Scenes.select_level(2))

func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file(Scenes.select_level(3))

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/MainMenu.tscn")
