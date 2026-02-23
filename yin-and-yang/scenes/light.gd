extends CharacterBody2D


@export var speed : float = 200.0
@export var jump_force : float = -400.0
@export var gravity : float = 900.0

var is_attacking : bool = false

@onready var sprite = $AnimatedSprite2D
@onready var light: CharacterBody2D = $"."


# -----------------------
# == PHYSICS PROCESS ==
# -----------------------

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta):

	 # Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	 # Movement input
	var direction = 0

	if Input.is_action_pressed("ui_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right"):
		direction += 1

	 # Apply horizontal movement
	if not is_attacking:
		velocity.x = direction * speed
	else:
		velocity.x = 0   # Stop while attacking

	 # Flip sprite
	if direction != 0:
		sprite.flip_h = direction < 0

	 # Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	 # Attack
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()

	 # Move character
	move_and_slide()

	 # Animations
	handle_animations(direction)


# -----------------------
# == ATTACK FUNCTION ==
# -----------------------

func attack():
	is_attacking = true
	sprite.play("attack")
	await get_tree().create_timer(0.4).timeout
	is_attacking = false

# -----------------------
# == ANIMATION HANDLER ==
# -----------------------

func handle_animations(direction):

	if is_attacking:
		return
	if not is_on_floor():
		sprite.play("jump")

	elif direction != 0:
		sprite.play("run")

	else:
		sprite.play("idle")


# -----------------------
# == ANIMATION FINISHED ==
# -----------------------

func _on_AnimatedSprite2D_animation_finished():

	if sprite.animation == "attack":
		is_attacking = false
