extends Control

@onready var light_score = $light_score
@onready var shadow_score = $shadow_score

func _ready() -> void:
	light_score.text = "Light: " + str(GameManager.white_score)
	shadow_score.text = "Shadow: " + str(GameManager.black_score)
