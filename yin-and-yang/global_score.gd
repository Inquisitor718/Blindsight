extends Node

var black_score = 0
var white_score = 0
var round_end = false
var round = 1



func _process(float):
	if round > 7:
		black_score = 0
		white_score = 0
		round = 1

func round_concluded():
	get_tree().reload_current_scene()
	round_end = false
	round+= 1
