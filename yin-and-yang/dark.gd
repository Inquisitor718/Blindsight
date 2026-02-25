extends CharacterBody2D

# Exports
@export var speed : float = 200.0
@export var jump_force : float = -400.0
@export var gravity : float = 900.0
@export var health = 30
#@export var clone_scene = preload("res://clone.tscn")
@onready var hit_box: Area2D = $HitBox
@onready var color_rect: ColorRect = $AnimatedSprite2D/ColorRect
@onready var light: CharacterBody2D = $"../Light"
@onready var dash_cooldown: Timer = $DashCooldown

# Attack vars
var is_attacking : bool = false

# Dash vars
var can_dash: bool = true
var dash_speed = 900
var is_dashing : bool = false

@onready var sprite = $AnimatedSprite2D
@onready var mat = color_rect.material as ShaderMaterial
# -----------------------
# == PHYSICS PROCESS ==
# -----------------------

func _physics_process(delta):
	var direction = 0
	 # Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	 # Movement input
	if Input.is_action_pressed("p1_left"):
		direction = -1
	if Input.is_action_pressed("p1_right"):
		direction = 1
	if Input.is_action_just_pressed("p1_dash") and not is_dashing and can_dash:
		
		start_dash()
		dash_cooldown.start()
		can_dash = false
		
	 # Apply horizontal movement
	if not is_attacking and not is_dashing:	
		velocity.x = direction * speed
	elif not is_attacking and is_dashing:
		velocity.x = direction * dash_speed 
	else:
		velocity.x = 0

	#if Input.is_action_just_pressed("p1_down"):
		#spawn_clone(direction)

	 # Flip sprite
	if direction != 0:
		sprite.flip_h = -direction < 0
		hit_box.position.x = 19.0 if -direction<0 else -19.0

	 # Jump
	if Input.is_action_just_pressed("p1_jump") and is_on_floor():
		velocity.y = jump_force

	 # Attack
	if Input.is_action_just_pressed("p1_attack") and not is_attacking:
		attack()

	 # Animations
	handle_animations(direction)
	
	if sprite.animation=="attack" && (sprite.frame == 1) && is_attacking:
		hit_box.monitoring = true
		DarkGlobals.hit_box_monitoring = true
	else:
		hit_box.monitoring = false
		DarkGlobals.hit_box_monitoring = false
	
	if(is_dashing):
		pass
		
	move_and_slide()

# -----------------------
# == ATTACK FUNCTION ==
# -----------------------

func attack():
	is_attacking = true
	hit_box.add_to_group("attack")
	sprite.play("attack")
	await get_tree().create_timer(0.4).timeout
	is_attacking = false
	
	
func start_dash():
	is_dashing = true
	await get_tree().create_timer(0.1).timeout
	is_dashing = false
	
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


 
func _on_dash_cooldown_timeout() -> void:
	can_dash = true


func take_damage() -> void:
	health -= 10
	if(health<=0):
		sprite.play("Dead")
		Global_score.white_score += 1
		
		Global_score.round_end = true
		Global_score.round_concluded()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		#print("goli lagi")
		take_damage()
#
#func spawn_clone(direction):
	#var clone = clone_scene.instantiate()
	#clone.global_position = global_position
	#clone.direction = direction
#
	#get_parent().add_child(clone)
