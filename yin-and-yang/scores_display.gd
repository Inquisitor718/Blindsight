extends CanvasLayer

@onready var light_score = $light_score
@onready var shadow_score = $shadow_score

func _process(_delta) -> void:
	light_score.text = "Anora : " + str(GameManager.white_score)
	shadow_score.text = "Oni : " + str(GameManager.black_score)
	
