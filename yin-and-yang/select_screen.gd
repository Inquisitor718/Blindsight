extends CanvasLayer

@onready var main_bgm: AudioStreamPlayer2D = $main_bgm
@onready var button: AudioStreamPlayer2D = $button
@onready var wasd: Sprite2D = $wasd
@onready var ijkl: Sprite2D = $ijkl
@onready var left: TextureButton = $Left
@onready var right: TextureButton = $Right
@onready var play: TextureButton = $Play

func _ready() -> void:
	main_bgm.play()


func _on_left_pressed() -> void:
	wasd.global_position.x = 300.0
	ijkl.global_position.x = 1600.0
	GameManager.selection = 1
	left.disabled = true
	right.disabled = false
	play.disabled = false
	button.play()


func _on_right_pressed() -> void:
	wasd.global_position.x = 1600.0
	ijkl.global_position.x = 300.0
	GameManager.selection = 2
	left.disabled = false
	right.disabled = true
	play.disabled = false
	button.play()


func _on_play_pressed() -> void:
	GameManager.start_round()
