extends Node2D
@onready var gpu_particles_2d: GPUParticles2D = $Path2D/PathFollow2D/GPUParticles2D
#.process_material as ParticleProcessMaterial
@onready var mat= ($Path2D/PathFollow2D/GPUParticles2D).process_material as ParticleProcessMaterial

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("PLAYER"):
		#body.update_spawn_width()
		#mat.emission_box_extents.x = body.width / 2.0
		
		gpu_particles_2d.emitting = true
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("PLAYER"):
		gpu_particles_2d.emitting = false
