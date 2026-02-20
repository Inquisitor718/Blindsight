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

func _physics_process(delta):

	 # Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	 # Movement input
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_dir = input_dir.normalized()
	 # Apply horizontal movement
	if not is_attacking:
		velocity.x = input_dir.x * speed
	else:
		velocity.x = 0   # Stop while attacking

	if input_dir != Vector2.ZERO:
		$Torch.rotation = input_dir.angle()
		sprite.flip_h = input_dir.x < 0
	 # Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	 # Attack
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()

	 # Move character
	move_and_slide()

	 # Animations
	handle_animations(input_dir.x)


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


func _on_torch_body_entered(body: Node2D) -> void:
	if body.is_in_group("dark"):
		body.show_dark()


func _on_torch_body_exited(body: Node2D) -> void:
	if body.is_in_group("dark"):
		body.hide_dark()
	
	
