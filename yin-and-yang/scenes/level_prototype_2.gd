extends Node2D
@onready var mat: ShaderMaterial = $TileMapLayer.material
@export var flash_duration = 1.0
@onready var lightning_timer: Timer = $LightningTimer
var rng = RandomNumberGenerator.new()
@export var min_lightning_time = 5.0
@export var max_lightning_time = 10.0

func _ready():
	lightning()
	set_random_wait_time()
	lightning_timer.start()
	
func lightning():
	await trigger_glow(0.4, 10)
	await trigger_glow(0.08, 5)
	await trigger_glow(0.6, 3)

func trigger_glow(time, intensity):
	var t = 0.0
	
	while t < time:
		t += get_process_delta_time()
		mat.set_shader_parameter("glow_time", time - t)
		mat.set_shader_parameter("glow_strength", intensity)
		if get_tree() == null:
			return
		else:
			await get_tree().process_frame
	
	mat.set_shader_parameter("glow_time", 0.0)

func set_random_wait_time() -> void:
	rng.randomize()
	var random_time = rng.randf_range(min_lightning_time, max_lightning_time)
	lightning_timer.set_wait_time(random_time)
	#print(random_time)

func _on_lightning_timer_timeout() -> void:
	lightning()
	set_random_wait_time()
	lightning_timer.start()
	
