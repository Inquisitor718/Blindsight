extends CharacterBody2D
class_name ShadowClone

@export var speed:= 700.0
@export var acceleration:= 5000.
@export var gravity:= 3500.0
@export var knockback_strength:= 1500.
@export var hp := 1

@export_category("Dependencies")
@export var sprite: AnimatedSprite2D
@export var walk_particles: GPUParticles2D
@export var wall_ray_cast: RayCast2D
@export var fall_ray_cast: RayCast2D
@onready var oni_sprite: AnimatedSprite2D = $AnimatedSprite2D2


var direction := 1
signal destroyed

func _ready() -> void:
	await get_tree().process_frame
	update_rays()

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	move_and_slide()
	
	wall_ray_cast.force_raycast_update()
	fall_ray_cast.force_raycast_update()
	
	if wall_ray_cast.is_colliding():
		reverse()
	if not fall_ray_cast.is_colliding():
		reverse()

func reverse():
	direction *= -1
	sprite.flip_h = direction < 0
	update_rays()

func update_rays():
	wall_ray_cast.target_position.x = abs(wall_ray_cast.target_position.x) * direction
	fall_ray_cast.target_position.x = abs(fall_ray_cast.target_position.x) * direction

func handle_animations():
	if direction != 0:
		sprite.play("run")
	else:
		sprite.play("idle")

func take_damage(dmg: int, dir: Vector2) -> void:
	hp -= dmg
	velocity = Vector2(sign(dir.x) * knockback_strength, -knockback_strength/3.)
	if hp <= 0:
		destroyed.emit()
		
		queue_free()
		

#func _on_hurtbox_area_entered(area: Area2D) -> void:
	#if area.is_in_group("projectile"):
		#take_damage()
