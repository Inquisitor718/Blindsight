extends PlayerBase
class_name LightPlayer

@export_category("Light Player Variables")
@export var projectile_speed := 1750.
@export var projectile_cooldown := 0.5
var current_projectile_cooldown := 0.


@export_category("Dependencies")
@export var sprite: Node2D

func _process(delta: float) -> void:
	current_projectile_cooldown -= delta
	sprite.scale.x = direction if direction != 0 else 1

func _physics_process(delta: float) -> void:
	move(\
	int(Input.get_axis("p1_left", "p1_right")),\
	is_on_floor() and Input.is_action_just_pressed("p1_jump"),\
	Input.is_action_just_pressed("p1_down"),\
	Input.is_action_just_pressed("p1_attack"),\
	delta
	)

func drop_ability():
	var new_lantern : LightLantern = preload("res://scenes/characters/light_lantern.tscn").instantiate()
	add_sibling(new_lantern)
	new_lantern.global_position = global_position
	

func attack_ability():
	if current_projectile_cooldown > 0.:
		return
	current_projectile_cooldown = projectile_cooldown
	
	var new_projectile : LightProjectile = preload("res://scenes/characters/light_projectile.tscn").instantiate()
	add_sibling(new_projectile)
	new_projectile.spawn(global_position, Vector2(float(direction), 0.), projectile_speed, self)

func take_damage(dmg: int, dir: Vector2):
	hp -= dmg
	velocity.x = sign(dir.x) * knockback_strength
	prints("light takes damage", dmg, "current hp:", hp)
