extends CanvasLayer
class_name LightningFlasher

@export var tilemap: TileMapLayer

@export_category("Dependencies")
@export var lightning_timer: Timer
@export var flash_duration = 1.5
@export var min_lightning_time = 5.0
@export var max_lightning_time = 10.0
@export var lightning_mat: ShaderMaterial
@onready var thunder: AudioStreamPlayer2D = $thunder
@onready var lightning_light: PointLight2D = $PointLight2D


var mat: ShaderMaterial 
var rng = RandomNumberGenerator.new()

func _ready():
	set_random_wait_time()
	lightning_timer.start()
	lightning_light.hide()
	
	if tilemap:
		tilemap.set_material(lightning_mat)
		mat = tilemap.material
	
	
func lightning():
	if !GameManager.lightning_enabled:
		return
	thunder.play()
	GameManager._bijli_aayi()
	await trigger_glow(0.4, 4)
	if !GameManager.lightning_enabled: return
	await trigger_glow(0.08, 3)
	if !GameManager.lightning_enabled: return
	await trigger_glow(0.6, 1)
	if !GameManager.lightning_enabled: return

func trigger_glow(time, intensity):
	if mat == null:
		return
	
	
	var t = 0.0
	lightning_light.show()
	while t < time:
		t += get_process_delta_time()
		mat.set_shader_parameter("glow_time", time - t)
		mat.set_shader_parameter("glow_strength", intensity)
		if get_tree() == null: 
			return
		else:
			await get_tree().process_frame
	
	mat.set_shader_parameter("glow_time", 0.0)
	lightning_light.hide()
	return

func set_random_wait_time() -> void:
	rng.randomize()
	var random_time = rng.randf_range(min_lightning_time, max_lightning_time)
	lightning_timer.set_wait_time(random_time)
	print(random_time)

func _on_lightning_timer_timeout() -> void:
	lightning()
	set_random_wait_time()
	lightning_timer.start()
	
