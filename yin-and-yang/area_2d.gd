extends Area2D

@export var speed = 600
var direction = Vector2(0,0)

func _physics_process(delta):
	position += direction*speed*delta
