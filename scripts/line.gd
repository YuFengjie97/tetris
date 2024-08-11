extends Node2D
class_name Line

signal clear_done


var is_cleared = false
var position_y
var piece_clear_num = 0
var piece_move_down_num = 0


func check_full():
	var spieces = get_children().filter(func(c): return c is Piece)
	return spieces.size() == Global.cols


func clear():
	for piece in get_children().filter(func(c): return c is Piece) as Array[Piece]:
		piece.clear_done.connect(on_piece_clear)
		piece.clear()


func on_piece_clear():
	piece_clear_num += 1
	if piece_clear_num == Global.cols:
		is_cleared = true
		clear_done.emit()
		queue_free()

func update_position_y():
	position_y += Global.grid_size

func move_down():
	for piece in get_children().filter(func (c): return c is Piece):
		var tween = get_tree().create_tween()
		tween.tween_property(piece, 'position:y', position_y, 0.1)
