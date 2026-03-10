extends PlayerBase
class_name ShadowPlayer

@export_category("Shadow Player Variables")
@export var attack_range := 220.
@export var attack_cooldown := 0.4
@export var shadow_clone_limit := 6
var current_attack_cooldown := 0.
var clones_count:= 0
var id = ""

@export_category("Dependencies")
@export var sprite: Node2D
@export var hitbox: Area2D
var white_wins = preload("res://scenes/white_wins.tscn")

func _ready() -> void:
	if GameManager.selection == 1:
		id = "2"
	else:
		id = "1"

func _process(delta: float) -> void:
	current_attack_cooldown -= delta
	sprite.scale.x = direction if direction != 0 else 1

func _physics_process(delta: float) -> void:
	if hp <= 0: return 
	move(\
	int(Input.get_axis("p" + id + "_left", "p" + id + "_right")),\
	Input.is_action_pressed("p" + id + "_jump"),\
	Input.is_action_just_pressed("p" + id + "_down"),\
	Input.is_action_just_pressed("p" + id + "_attack"),\
	delta
	)
	handle_visuals()

func handle_visuals():
	if walk_particles:
		walk_particles.emitting = is_on_floor() and not is_equal_approx(abs(velocity.x), 0.)

func drop_ability():
	if clones_count > shadow_clone_limit:
		return
	
	var new_clone: ShadowClone = preload("res://scenes/characters/shadow_clone.tscn").instantiate()
	add_sibling(new_clone)
	new_clone.global_position = global_position
	new_clone.direction = direction
	new_clone.global_position = global_position
	
	clones_count += 1
	var clone_destroyed = func():
		clones_count -= 1
	new_clone.destroyed.connect(clone_destroyed)

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
	if hp <= 0:
		return
	hp -= dmg
	velocity = Vector2(sign(dir.x) * knockback_strength, -knockback_strength/3.)
	prints("shadow takes damage", dmg, "current hp:", hp)
	if hp <= 0:
		die()

func die():
	
	GameManager.white_win = true
	GameManager.round_concluded()
	if death_particles: death_particles.emitting = true
	var death_tween = create_tween()
	death_tween.tween_property(self, "scale", Vector2.ZERO, .8)
	death_tween.set_parallel(true).tween_property(self, "rotation", rotation + 2*PI, .8)
	death_tween.set_parallel(false).tween_callback(func():
		queue_free())
		
