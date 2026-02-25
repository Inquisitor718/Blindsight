extends CanvasLayer
class_name LightningFlasher

@export var tilemap: TileMapLayer

@export_category("Dependencies")
@export var lightning_timer: Timer
@export var flash_duration = 1.5
@export var min_lightning_time = 5.0
@export var max_lightning_time = 10.0
@export var lightning_mat: ShaderMaterial

var mat: ShaderMaterial 
var rng = RandomNumberGenerator.new()

func _ready():
	lightning()
	set_random_wait_time()
	lightning_timer.start()
	
	if tilemap:
		tilemap.set_material(lightning_mat)
		mat = tilemap.material
	
func lightning():
	await trigger_glow(0.4, 4)
	await trigger_glow(0.08, 3)
	await trigger_glow(0.6, 1)

func trigger_glow(time, intensity):
	if not mat:
		return

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
	return

func set_random_wait_time() -> void:
	rng.randomize()
	var random_time = rng.randf_range(min_lightning_time, max_lightning_time)
	lightning_timer.set_wait_time(random_time)

func _on_lightning_timer_timeout() -> void:
	lightning()
	set_random_wait_time()
	lightning_timer.start()
	
