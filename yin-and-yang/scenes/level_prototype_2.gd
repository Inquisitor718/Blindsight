extends Node2D
@onready var mat: ShaderMaterial = $TileMapLayer.material

func _ready():
	trigger_glow()

func trigger_glow():
	print("trigger kiya")
	var t = 0.0
	
	while t < 1.0:
		t += get_process_delta_time()
		mat.set_shader_parameter("glow_time", 1.0 - t)
		if get_tree() == null:
			return
		else:
			await get_tree().process_frame
	
	mat.set_shader_parameter("glow_time", 0.0)
