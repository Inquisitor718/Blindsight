extends Control

@onready var oni_wins: Sprite2D = $OniWins
@onready var button: AudioStreamPlayer2D = $button

func _ready():
	if GameManager.winner == "Light":
		oni_wins.hide()

func _on_restart_button_pressed() -> void:
	GameManager.white_score = 0
	GameManager.black_score = 0
	button.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://main_menu.tscn")
	
