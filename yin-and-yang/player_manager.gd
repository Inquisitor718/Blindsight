extends Node

func spawn_players(scene):
	var pairs = scene.get_node("SpawnPairs").get_children()
	var pair = pairs.pick_random()
	
	var p1_marker = pair.get_node("P1")
	var p2_marker = pair.get_node("P2")
	
	var light_scene = preload("res://scenes/characters/light_player.tscn")
	var shadow_scene = preload("res://scenes/characters/shadow_player.tscn")
	
	var light_player = light_scene.instantiate()
	var shadow_player = shadow_scene.instantiate()
	
	light_player.global_position = p1_marker.global_position
	shadow_player.global_position = p2_marker.global_position
	
	scene.add_child(light_player)
	scene.add_child(shadow_player)
