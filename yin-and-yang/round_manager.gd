extends Node

var black_score = 0
var white_score = 0

var white_win: bool = false
var black_win: bool = false
var end_time = 1.0




func round_concluded():
	
	
	
	
	if white_win:
		white_score += 1
		print("white won")
		
		white_win = false
	
	if black_win:
		black_score += 1
		print("black won")
		
		black_win = false
		
	
	
	await get_tree().create_timer(end_time).timeout
	get_tree().reload_current_scene()
	
	
