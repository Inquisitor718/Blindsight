extends Node2D
@onready var mat: ShaderMaterial = $TileMapLayer.material
@export var flash_duration = 2.0

func _ready():
	trigger_glow()

func trigger_glow():
	print("trigger kiya")
	var t = 0.0
	
	while t < flash_duration:
		t += get_process_delta_time()
		mat.set_shader_parameter("glow_time", flash_duration - t)
		if get_tree() == null:
			return
		else:
			await get_tree().process_frame
	
	mat.set_shader_parameter("glow_time", 0.0)
