extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var skewValue := 200
@export var bendGrassnimationSpeed = 0.3
@export var grassReturnAnimationSpeed = 5.0

func _on_body_entered(body: Node2D) -> void:
	print("Something entered:", body.name)

	if not body.is_in_group("player"):
		return

	print("Player detected!")

	var direction = global_position.direction_to(body.global_position)
	var skew: float = -direction.x * skewValue

	var tween = create_tween()
	tween.tween_property(
		sprite_2d.material,
		"shader_parameter/skew",
		skew,
		bendGrassnimationSpeed
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	tween.tween_property(
		sprite_2d.material,
		"shader_parameter/skew",
		0.0,
		grassReturnAnimationSpeed
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
