extends Control

@onready var winner_label = $WinnerLabel

func _ready():
	winner_label.text = GameManager.winner + " Wins!"

func _on_restart_button_pressed() -> void:
	GameManager.white_score = 0
	GameManager.black_score = 0
	get_tree().change_scene_to_file("res://main.tscn")
	
