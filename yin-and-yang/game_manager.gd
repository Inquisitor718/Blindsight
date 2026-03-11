extends Node

var black_score = 0
var white_score = 0
var winner = ""
var selection: int
@export var rounds = 10
var light_agayi: bool = false


var white_win: bool = false
var black_win: bool = false
var end_time = 1.5

func start_round():
	var score_display = get_tree().current_scene.get_node("Scores")
	score_display.show()
	
	var select_screen = get_tree().current_scene.get_node("SelectScreen") 
	if select_screen:
		select_screen.hide()
	
	var scene_manager = get_tree().current_scene.get_node("SceneManager")
	var player_manager = get_tree().current_scene.get_node("PlayerManager")
	
	var scene = scene_manager.load_random_scene()
	player_manager.spawn_players(scene)

func round_concluded():
	if white_win:
		white_score += 1
		print("light won")
		white_win = false
	
	if black_win:
		black_score += 1
		print("shadow won")
		black_win = false
	
	print("light score:", white_score)
	print("shadow score:", black_score)
	
	await get_tree().create_timer(end_time).timeout
	
	if white_score == rounds:
		winner = "Light"
		get_tree().change_scene_to_file("res://end_screen.tscn")
	elif black_score == rounds:
		winner = "Shadow"
		get_tree().change_scene_to_file("res://end_screen.tscn")
	else:
		start_round()



#func _bijli_aayi():
	#light_agayi=true
	#print("yay")
	#await get_tree().create_timer(1.5).timeout
	#light_agayi = false
	#print("shit")
