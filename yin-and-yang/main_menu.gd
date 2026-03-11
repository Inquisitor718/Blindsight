extends Node2D

@onready var button: AudioStreamPlayer2D = $button

func _on_play_pressed() -> void:
	button.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://main.tscn")

func _on_quit_pressed() -> void:
	button.play()
	get_tree().quit()
