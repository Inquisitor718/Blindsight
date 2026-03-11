extends Control


@onready var end_sound: AudioStreamPlayer2D = $end_sound
@onready var oni_wins: Sprite2D = $OniWins

func _ready():
	end_sound.play()
	if GameManager.winner == "Light":
		oni_wins.hide()

func _on_restart_button_pressed() -> void:
	GameManager.white_score = 0
	GameManager.black_score = 0
	get_tree().change_scene_to_file("res://main_menu.tscn")
	
