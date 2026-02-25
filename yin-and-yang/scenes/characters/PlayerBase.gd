@abstract
extends CharacterBody2D
class_name PlayerBase

@export_category("Player Variables")
@export var move_speed := 700.
@export var jump_height := 430.
@export var gravity := 3500.
@export var acceleration := 5000.
@export var knockback_strength := 1300.
@export var hp := 2
var direction: int = 1

func move(dir: int, jump: bool, drop: bool, attack: bool, delta: float):
	if dir != 0: direction = dir
	velocity.y += gravity * delta
	velocity.x = move_toward(velocity.x, dir * move_speed, acceleration * delta)
	if jump: velocity.y = - sqrt(2. * gravity * jump_height)
	if drop: drop_ability()
	if attack: attack_ability()
	move_and_slide()

func drop_ability():
	pass

func attack_ability():
	pass
