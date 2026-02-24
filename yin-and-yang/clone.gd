extends CharacterBody2D

@export var speed : float = 200.0
@export var gravity : float = 900.0
@export var health = 10;
@onready var hit_box: Area2D = $HitBox
@onready var color_rect: ColorRect = $AnimatedSprite2D/ColorRect
@onready var light: CharacterBody2D = $"../Light"
@onready var sprite = $AnimatedSprite2D
@onready var mat = color_rect.material as ShaderMaterial
var direction := 1

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = direction * speed
	move_and_slide()
	
	if $WallRayCast.is_colliding():
		reverse()
	if not $FallRayCast.is_colliding():
		reverse()

func reverse():
	direction = -1
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


func take_damage() -> void:
	health -= 10
	if health == 0:
		queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		take_damage()
