extends CanvasLayer

@onready var label: Label = $Label

func _process(float):
	label.text = "Black: %s White: %s Round: %s" %[Global_score.black_score, Global_score.white_score, Global_score.round]
