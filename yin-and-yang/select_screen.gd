extends CanvasLayer

@onready var main_bgm: AudioStreamPlayer2D = $main_bgm
@onready var button: AudioStreamPlayer2D = $button

func _ready() -> void:
	main_bgm.play()

func _on_light_button_pressed() -> void:
	GameManager.selection = 1
	button.play()
	GameManager.start_round()

func _on_shadow_button_pressed() -> void:
	GameManager.selection = 2
	button.play()
	GameManager.start_round()
