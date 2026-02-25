extends Node2D
class_name LightLantern

func take_damage(_dmg: int, _dir: Vector2):
	queue_free()
