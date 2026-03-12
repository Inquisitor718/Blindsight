@abstract
extends CharacterBody2D
class_name PlayerBase

enum State { IDLE, RUN, IN_AIR }
var state: State = State.IDLE

@export_category("Player Variables")
@export var move_speed := 700.
@export var min_jump_height := 150.
@export var min_jump_hold_time := 0.05
@export var max_jump_hold_time := 0.3
@export var jump_hold_acc := 5600.
@export var max_coyote_time := 0.1
@export var gravity := 4000.
@export var acceleration := 6000.
@export var knockback_strength := 2000.
@export var hp := 2

var direction: int = 1:
	set(value):
		set_direction(value)
		direction = value
var _jump_held_time := 0.
var _coyote_time := 0.
var _jump_on_last_frame := false

@export_category("Base dependencies")
@export var walk_particles: GPUParticles2D
@export var jump_particles: GPUParticles2D
@export var death_particles: GPUParticles2D

func set_direction(_value: int):
	pass

func move(dir: int, jump: bool, drop: bool, attack: bool, delta: float):
	if dir != 0:
		direction = dir

	velocity.y += gravity * delta
	velocity.x = move_toward(velocity.x, dir * move_speed, acceleration * delta)

	_process_state(dir, jump, delta)

	if drop:
		drop_ability()

	if attack:
		attack_ability()

	move_and_slide()
	
	_jump_on_last_frame = jump


func _process_state(dir: int, jump: bool, delta: float):
	match state:

		State.IDLE:
			if not is_on_floor():
				_transition(State.IN_AIR)

			elif dir != 0:
				_transition(State.RUN)
			
			if jump and is_on_floor() and _not_jump_echo():
				_transition(State.IN_AIR, {"jump": true})


		State.RUN:
			if not is_on_floor():
				_transition(State.IN_AIR)

			elif dir == 0:
				_transition(State.IDLE)
			
			if jump and is_on_floor() and _not_jump_echo():
				_transition(State.IN_AIR, {"jump": true})


		State.IN_AIR:
			if is_on_floor():
				if dir == 0:
					_transition(State.IDLE)
				else:
					_transition(State.RUN)
			
			_coyote_time += delta
			if _coyote_time < max_coyote_time and jump and _not_jump_echo():
				_transition(State.IN_AIR, {"jump": true})
			
			_jump_held_time += delta
			if jump:
				if _jump_held_time < max_jump_hold_time and _jump_held_time > min_jump_hold_time:
					velocity.y -= jump_hold_acc * delta
			else:
				_jump_held_time = max_jump_hold_time + 0.1



func _transition(new_state: State, msg:={}):
	#exit state
	match state:
		State.IDLE:
			pass
		State.RUN:
			pass
		State.IN_AIR:
			if jump_particles:
				jump_particles.restart()
			pass
	
	state = new_state
	_enter_state(new_state, msg)



func _enter_state(new_state: State, msg:={}):
	match new_state:

		State.IDLE:
			if walk_particles:
				walk_particles.emitting = false

		State.RUN:
			if walk_particles:
				walk_particles.emitting = true

		State.IN_AIR:
			if walk_particles:
				walk_particles.emitting = false
			if jump_particles:
				jump_particles.restart()

			if msg.has("jump"):
				velocity.y = -sqrt(2. * gravity * min_jump_height)
				_jump_held_time = 0.
				_coyote_time = max_coyote_time + 0.1
			else:
				_coyote_time = 0.



func drop_ability():
	pass


func attack_ability():
	pass


func die():
	pass

func _not_jump_echo() -> bool:
	return not _jump_on_last_frame
