extends Area2D
class_name LightProjectile

var projectile_direction: Vector2
var projectile_speed: float
var projectile_shooter: Node2D
var shot:= false

func _ready() -> void:
	hide()

func _physics_process(delta: float) -> void:
	if not shot:
		return
	show()
	position += projectile_direction * projectile_speed * delta

func spawn(pos: Vector2, dir: Vector2, speed: float, shooter: Node2D = null): ### shooter == node which shot this
	global_position = pos
	projectile_direction = dir
	projectile_speed = speed
	projectile_shooter = shooter
	shot = true

func _on_body_entered(body: Node2D) -> void:
	if not shot:
		return
	if body is LightPlayer:
		return
	hit_and_destroy(body)

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is LightPlayer:
		return
	hit_and_destroy(area)

func hit_and_destroy(hit_obj: Node2D):
	if hit_obj is Hurtbox:
		if not hit_obj.get_parent() is LightPlayer:
			hit_obj.take_damage(1, global_position.direction_to(hit_obj.global_position))
	collision_mask = 0
	queue_free()
