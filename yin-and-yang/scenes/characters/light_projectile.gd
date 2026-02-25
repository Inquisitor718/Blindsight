extends Area2D
class_name LightProjectile

@export var explosion_light : PointLight2D
@export var light_flash_time := 0.8
@export var projectile_max_distance := 1200.

var projectile_lifetime: float
var projectile_direction: Vector2
var projectile_speed: float
var projectile_shooter: Node2D
var shot:= false

func _physics_process(delta: float) -> void:
	if not shot:
		return
	show()
	rotation += 2 * PI * delta
	position += projectile_direction * projectile_speed * delta
	projectile_lifetime -= delta
	if projectile_lifetime <= 0.:
		destroy()

func spawn(pos: Vector2, dir: Vector2, speed: float, shooter: Node2D = null): ### shooter == node which shot this
	global_position = pos
	projectile_direction = dir
	projectile_speed = speed
	projectile_shooter = shooter
	projectile_lifetime = projectile_max_distance / projectile_speed
	shot = true

func _on_body_entered(body: Node2D) -> void:
	if not shot:
		return
	if body is PlayerBase or body is ShadowClone:
		return
	hit(body)
	destroy()

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is LightPlayer or area.get_parent() is LightLantern:
		return
	hit(area)
	destroy()

func hit(hit_obj: Node2D):
	if hit_obj is Hurtbox:
		hit_obj.take_damage(1, global_position.direction_to(hit_obj.global_position))

func destroy():
	collision_mask = 0
	shot = false
	$ColorRect.hide()
	explosion_light.show()
	var tween = get_tree().create_tween()
	tween.tween_property(explosion_light, "energy", 0, light_flash_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(func():
		queue_free())
		
