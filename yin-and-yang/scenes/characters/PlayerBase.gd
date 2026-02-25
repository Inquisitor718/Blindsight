@abstract
extends CharacterBody2D
class_name PlayerBase

@export_category("Player Variables")
@export var move_speed := 700.
@export var jump_height := 430.
@export var gravity := 3500.
@export var acceleration := 5000.
@export var knockback_strength := 1500.
@export var hp := 2
var direction: int = 1

@export_category("Base dependencies")
@export var walk_particles: GPUParticles2D
@export var jump_particles: GPUParticles2D
@export var death_particles: GPUParticles2D

func move(dir: int, jump: bool, drop: bool, attack: bool, delta: float):
	if dir != 0: direction = dir
	velocity.y += gravity * delta
	velocity.x = move_toward(velocity.x, dir * move_speed, acceleration * delta)
	if jump: velocity.y = - sqrt(2. * gravity * jump_height)
	if drop: drop_ability()
	if attack: attack_ability()
	
	var was_in_air = not is_on_floor()
	
	move_and_slide()
	
	if walk_particles:
		walk_particles.emitting = is_on_floor() and not is_equal_approx(abs(velocity.x), 0.)
	if jump_particles:
		if (was_in_air and is_on_floor()) or jump:
			jump_particles.restart()

func drop_ability():
	pass

func attack_ability():
	pass

func die():
	pass
