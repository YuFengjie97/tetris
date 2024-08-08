extends Node2D
class_name Line

var position_y
var is_clear = false

func check_full():
	var spieces = get_children()
	return spieces.size() == Global.cols


func clear():
	is_clear = true
	queue_free()


func move_down():
	for piece in get_children():
		piece.position += Global.grid_size * Vector2.DOWN
	position_y += Global.grid_size
