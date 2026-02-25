extends PlayerBase
class_name LightPlayer

@export_category("Light Player Variables")
@export var projectile_speed := 1750.
@export var projectile_cooldown := 0.4
@export var lantern_limit := 3
var current_projectile_cooldown := 0.
var lanterns: Array[LightLantern]
var lanterns_count:= 0

@export_category("Dependencies")
@export var sprite: Node2D

func _process(delta: float) -> void:
	current_projectile_cooldown -= delta
	sprite.scale.x = direction if direction != 0 else 1

func _physics_process(delta: float) -> void:
	if hp <= 0: return
	move(\
	int(Input.get_axis("p1_left", "p1_right")),\
	is_on_floor() and Input.is_action_just_pressed("p1_jump"),\
	Input.is_action_just_pressed("p1_down"),\
	Input.is_action_just_pressed("p1_attack"),\
	delta
	)

func drop_ability():
	if lanterns_count > lantern_limit:
		return
	var new_lantern : LightLantern = preload("res://scenes/characters/light_lantern.tscn").instantiate()
	add_sibling(new_lantern)
	new_lantern.global_position = global_position
	lanterns_count += 1
	var lantern_destroyed = func():
		lanterns_count -= 1
	new_lantern.destroyed.connect(lantern_destroyed)
	

func attack_ability():
	if current_projectile_cooldown > 0.:
		return
	current_projectile_cooldown = projectile_cooldown
	
	var new_projectile : LightProjectile = preload("res://scenes/characters/light_projectile.tscn").instantiate()
	add_sibling(new_projectile)
	new_projectile.spawn(global_position, Vector2(float(direction), 0.), projectile_speed, self)

func take_damage(dmg: int, dir: Vector2):
	if hp <= 0:
		return
	hp -= dmg
	velocity = Vector2(sign(dir.x) * knockback_strength, -knockback_strength/3.)
	prints("light takes damage", dmg, "current hp:", hp)
	if hp <= 0:
		die()

func die():
	if death_particles: death_particles.emitting = true
	var death_tween = create_tween()
	death_tween.tween_property(self, "scale", Vector2.ZERO, .8)
	death_tween.set_parallel(true).tween_property(self, "rotation", rotation + 2*PI, .8)
	death_tween.set_parallel(false).tween_callback(func():
		queue_free())
		
