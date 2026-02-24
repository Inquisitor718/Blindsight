extends CharacterBody2D
class_name ShadowClone

@export var speed:= 700.0
@export var acceleration:= 4000.
@export var gravity:= 3500.0
@export var hp := 1
@export var sprite : AnimatedSprite2D

var direction := 1

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	move_and_slide()
	
	$WallRayCast.force_raycast_update()
	$FallRayCast.force_raycast_update()
	
	if $WallRayCast.is_colliding():
		reverse()
	if not $FallRayCast.is_colliding():
		reverse()

func reverse():
	direction *= -1
	sprite.flip_h = direction < 0
	update_rays()

func update_rays():
	$WallRayCast.target_position.x = abs($WallRayCast.target_position.x) * direction
	$FallRayCast.target_position.x = abs($FallRayCast.target_position.x) * direction

func handle_animations():
	if direction != 0:
		sprite.play("run")
	else:
		sprite.play("idle")

func take_damage(dmg: int, dir: Vector2) -> void:
	hp -= dmg
	if hp <= 0:
		queue_free()

#func _on_hurtbox_area_entered(area: Area2D) -> void:
	#if area.is_in_group("projectile"):
		#take_damage()
