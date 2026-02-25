extends Node2D
class_name LightLantern

@export var hp:= 1

func take_damage(dmg: int, _dir: Vector2):
	hp -= dmg
	if hp <= 0:
		queue_free()
