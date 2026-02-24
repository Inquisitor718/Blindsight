extends Area2D
class_name Hurtbox

signal dmg_taken(dmg: int, dir: Vector2)

func take_damage(dmg: int, dir: Vector2 = Vector2.ZERO):
	dmg_taken.emit(dmg, dir)
