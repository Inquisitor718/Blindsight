extends CharacterBody2D


@export var speed : float = 200.0
@export var jump_force : float = -400.0
@export var gravity : float = 900.0
@onready var sprite = $AnimatedSprite2D
@onready var light: CharacterBody2D = $"."
@export var projectile_scene = preload("uid://gmt7dm0r2xto")


var holding_light: bool
var controls: bool = true
var health = 20;
var is_attacking : bool = false
var is_hittable: bool = false
var can_shoot: bool
var last_direction
var fire_rate: float = 1.0
# -----------------------
# == PHYSICS PROCESS ==
# -----------------------

func _ready() -> void:
	holding_light = true
	$PointLight2D2.shadow_enabled = false
	await get_tree().create_timer(.5).timeout
	
	if controls == false:
		holding_light = false
	$PointLight2D2.shadow_enabled = true

func _physics_process(delta):
	 # Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	 # Movement input

	var direction : int
	if controls == true:
		if Input.is_action_pressed("p2_left"):
			direction = -1
		if Input.is_action_pressed("p2_right"):
			direction = 1
	
	# Jump
		if Input.is_action_just_pressed("p2_jump") and is_on_floor():
			velocity.y = jump_force

	 # Attack
		if Input.is_action_just_pressed("p2_attack") and can_shoot:
			shoot()
	
	else :
		if Input.is_action_pressed("p2_left"):
			direction = -1
		if Input.is_action_pressed("p2_right"):
			direction = 1
	 
		if Input.is_action_just_pressed("p2_jump") and is_on_floor():
			velocity.y = jump_force

		 # Attack
		if Input.is_action_just_pressed("p2_attack") and can_shoot:
			shoot()

	
	# Apply horizontal movement
	if can_shoot:
		velocity.x = direction * speed
	else:
		velocity.x = 0   # Stop while attacking

	 # Flip sprite
	if direction != 0:
		$PointLight2D2.scale.x = sign(direction)
		sprite.flip_h = direction < 0
		$Torch2.scale.x = sign(direction)


	


	 # Move character
	move_and_slide()

	 # Animations
	handle_animations(direction)
	
	# Take Damage
	if is_hittable && DarkGlobals.hit_box_monitoring:
		take_damage()

# -----------------------
# == ATTACK FUNCTION ==
# -----------------------

#func attack():
	#is_attacking = true
	#sprite.play("attack")
	#await get_tree().create_timer(0.4).timeout
	#is_attacking = false

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


func take_damage() -> void:
	health-=1;
	#print(health)
	if(health<=0):
		sprite.play("Dead")


func _on_hurt_box_area_entered(_area: Area2D) -> void:
	is_hittable = true


func _on_hurt_box_area_exited(_area: Area2D) -> void:
	is_hittable = false
	can_shoot = true


func _on_torch_body_entered(body: Node2D) -> void:
	if body.is_in_group("dark"):
		body.show_dark()


func _on_torch_body_exited(body: Node2D) -> void:
	if body.is_in_group("dark"):
		body.hide_dark()
	
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var input_dir = Vector2(Input.get_action_strength("p2_right") - Input.get_action_strength("p2_left"), Input.get_action_strength("p2_jump") - Input.get_action_strength("p2_down"))
	
	if input_dir!=Vector2(0,0):
		last_direction = input_dir.normalized()
		
	if Input.is_action_just_pressed("p2_attack") and can_shoot:
		shoot()
			
func shoot():
	can_shoot = false
	
	var projectile = projectile_scene.instantiate()
	projectile.position = global_position
	projectile.direction = last_direction
	
	get_parent().add_child(projectile)
	
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
	
