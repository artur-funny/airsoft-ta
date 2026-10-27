extends ColorRect

const needed_score_text: String = " de %d pontos necessários"
@onready var label = $VBoxContainer/EndLabel

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	label.text = (label.text % Scenes.player_score)
	if (Scenes.needed_score > 0):
		label.text += (needed_score_text % Scenes.needed_score)

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(Scenes.main_menu)

func _on_next_level_button_pressed() -> void:
	get_tree().change_scene_to_file(Scenes.next_level())
