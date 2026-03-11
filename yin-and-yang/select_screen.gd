extends Control

func _on_light_button_pressed() -> void:
	GameManager.selection = 1
	GameManager.start_round()

func _on_shadow_button_pressed() -> void:
	GameManager.selection = 2
	GameManager.start_round()
