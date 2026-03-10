extends Node

var scenes = [
	preload("res://scenes/Levels/test_level_1.tscn"),
	preload("res://scenes/Levels/test_level_2.tscn")
]

var current_scene: Node

func load_random_scene():
	if current_scene:
		current_scene.queue_free()
	var picked_scene = scenes.pick_random()
	current_scene = picked_scene.instantiate()
	
	var scene_container = get_parent().get_node("SceneContainer")
	scene_container.add_child(current_scene)
	
	return current_scene
	
	
	
