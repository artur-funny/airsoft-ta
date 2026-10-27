extends Control



func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(Scenes.start_game())


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file(Scenes.current_level())


func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file(Scenes.level_select)


func _on_quit_pressed() -> void:
	get_tree().quit()
