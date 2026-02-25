extends PlayerBase
class_name ShadowPlayer

@export_category("Shadow Player Variables")
@export var attack_range := 220.
@export var attack_cooldown := 0.3
var current_attack_cooldown := 0.

@export_category("Dependencies")
@export var sprite: Node2D
@export var walk_particles: GPUParticles2D
@export var hitbox: Area2D

func _process(delta: float) -> void:
	current_attack_cooldown -= delta
	sprite.scale.x = direction if direction != 0 else 1

func _physics_process(delta: float) -> void:
	move(\
	int(Input.get_axis("p2_left", "p2_right")),\
	is_on_floor() and Input.is_action_just_pressed("p2_jump"),\
	Input.is_action_just_pressed("p2_down"),\
	Input.is_action_just_pressed("p2_attack"),\
	delta
	)
	handle_visuals()

func handle_visuals():
	if walk_particles:
		walk_particles.emitting = is_on_floor() and not is_equal_approx(abs(velocity.x), 0.)


func drop_ability():
	var new_clone = preload("res://scenes/characters/shadow_clone.tscn").instantiate()
	add_sibling(new_clone)
	new_clone.global_position = global_position

func attack_ability():
	if current_attack_cooldown > 0.:
		return
	current_attack_cooldown = attack_cooldown
	$AnimationPlayer.play("attack")

	#var space_state = get_world_2d().direct_space_state
	#var query := PhysicsRayQueryParameters2D.create(\
	#global_position,\
	#global_position + Vector2(float(direction) * attack_range, 0.),\
	#2 ** 1 + 2 ** 2,\
	#)
	#query.collide_with_areas = true
	#query.collide_with_bodies = false
	#var result := space_state.intersect_ray(query)
	#if not result:
		#return
#
	#var hit_obj: Node2D = result.collider
	
	if not hitbox:
		return
	var areas := hitbox.get_overlapping_areas()

	var hurtboxes: Array[Hurtbox]
	for hb in areas:
		if not hb is Hurtbox:
			return
		if hb.get_parent() is ShadowPlayer or hb.get_parent() is ShadowClone:
			continue
		hurtboxes.append(hb)
	
	for hit_obj in hurtboxes:
		hit_obj.take_damage(1, global_position.direction_to(hit_obj.global_position))
	
func take_damage(dmg: int, dir: Vector2):
	hp -= dmg
	velocity.x = sign(dir.x) * knockback_strength
	prints("shadow takes damage", dmg, "current hp:", hp)
