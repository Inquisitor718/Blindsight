extends Path2D

@onready var path_follow_2d: PathFollow2D = $PathFollow2D
@onready var gpu_particles_2d: GPUParticles2D = $PathFollow2D/GPUParticles2D
@export var speed = 0.5;
var start_point

func _ready() -> void:
	start_point = randi_range(0,1)
	path_follow_2d.progress = start_point

func _physics_process(delta: float) -> void:
	if visible:
		visible = true
		gpu_particles_2d.emitting = true
		if start_point == 0:
			path_follow_2d.progress_ratio += speed * delta
		else:
			path_follow_2d.progress_ratio -= speed * delta
		if path_follow_2d.progress >= $".".curve.get_baked_length():
			path_follow_2d.progress = 1 if start_point>0 else 0
		#print(path_follow_2d.progress)
		
