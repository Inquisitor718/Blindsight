extends Node2D
var start_next = false
@onready var child = get_children()[randi_range(0,get_child_count()-2)]
@onready var timer: Timer = $"../Timer"

func _physics_process(delta: float) -> void:
	if start_next:
		choose_random()

func choose_random() -> void:
	child = get_children()[randi_range(0,get_child_count()-2)]
	child.visible = true
	print(child.get_index())
	start_next = false
	#child.visible = false


func _on_timer_timeout() -> void:
	start_next = true
	child.visible = false
