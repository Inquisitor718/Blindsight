extends Node2D
@onready var mat: ShaderMaterial = $TileMapLayer.material
@export var flash_duration = 2.0
@onready var lightning_timer: Timer = $LightningTimer
var rng = RandomNumberGenerator.new()
@export var min_lightning_time = 5.0
@export var max_lightning_time = 10.0

func _ready():
	trigger_glow()
	set_random_wait_time()
	lightning_timer.start()
	

func trigger_glow():
	var t = 0.0
	
	while t < flash_duration:
		t += get_process_delta_time()
		mat.set_shader_parameter("glow_time", flash_duration - t)
		if get_tree() == null:
			return
		else:
			await get_tree().process_frame
	
	mat.set_shader_parameter("glow_time", 0.0)

func set_random_wait_time() -> void:
	rng.randomize()
	var random_time = rng.randf_range(min_lightning_time, max_lightning_time)
	lightning_timer.set_wait_time(random_time)
	print(random_time)

func _on_lightning_timer_timeout() -> void:
	trigger_glow()
	set_random_wait_time()
	lightning_timer.start()
	
