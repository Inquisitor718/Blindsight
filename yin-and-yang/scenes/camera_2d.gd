extends Camera2D


@export var target_a: Node2D
@export var target_b: Node2D

@export var min_zoom := 0.8   
@export var max_zoom := 2.5   

@export var zoom_speed := 5.0
@export var move_speed := 5.0

func _process(delta):

	if !target_a or !target_b:
		return

	var midpoint = (target_a.global_position + target_b.global_position) / 2.0

	global_position = global_position.lerp(midpoint, move_speed * delta)

	var distance = target_a.global_position.distance_to(target_b.global_position)

	
	var target_zoom_value = 400.0 / distance


	target_zoom_value = clamp(target_zoom_value, min_zoom, max_zoom)

	var target_zoom = Vector2(target_zoom_value, target_zoom_value)

	zoom = zoom.lerp(target_zoom, zoom_speed * delta)
	
