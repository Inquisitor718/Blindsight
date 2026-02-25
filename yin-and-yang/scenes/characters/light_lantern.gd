extends Node2D
class_name LightLantern

@export var hp:= 1
signal destroyed

func take_damage(dmg: int, _dir: Vector2):
	hp -= dmg
	if hp <= 0:
		destroyed.emit()
		queue_free()
