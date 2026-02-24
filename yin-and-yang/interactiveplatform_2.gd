extends StaticBody2D

@onready var area = $Area2D
@onready var particles = $GPUParticles2D

var players_inside = 0

func _ready():
	area.body_entered.connect(_on_area_2d_body_entered)
	area.body_exited.connect(_on_area_2d_body_exited)


func _on_area_2d_body_entered(body):
	if body.is_in_group("PLAYER"):
		players_inside += 1
		particles.emitting = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("PLAYER"):
		players_inside -= 1
		if players_inside <= 0:
			particles.emitting = false
