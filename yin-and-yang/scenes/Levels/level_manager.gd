extends Node
class_name LevelManager

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		get_tree().call_deferred("reload_current_scene")
