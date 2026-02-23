extends Area2D

@export var speed = 600.0
var direction = Vector2(0,0)

func _physics_process(delta):
	position += direction*speed*delta


func _on_body_entered(body: Node2D) -> void:
	queue_free() # Replace with function body.
