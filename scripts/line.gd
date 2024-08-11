extends Node2D
class_name Line

signal clear_finished
signal move_finished


var is_cleared = false
var pos_y
var piece_clear_num = 0
var piece_move_num = 0
var pieces: Array[Piece] = []

func check_full():
	var spieces = get_children().filter(func(c): return c is Piece)
	return spieces.size() == Global.cols


func add_piece(piece: Piece):
	piece.reparent(self)
	pieces.append(piece)
	piece.clear_finished.connect(_on_all_piece_clear)
	piece.move_finished.connect(_on_all_piece_move_finished)


func clear():
	is_cleared = true
	for piece in get_children().filter(func(c): return c is Piece) as Array[Piece]:
		piece.clear()


func _on_all_piece_clear():
	print()
	piece_clear_num += 1
	if piece_clear_num == Global.cols:
		queue_free()
		clear_finished.emit()
		print('line clear111111')

func set_pos_y_by_move_down():
	pos_y += Global.grid_size 


func move_down():
	piece_move_num = 0
	for piece in get_children().filter(func (c): return c is Piece) as Array[Piece]:
		piece.move(pos_y)


func _on_all_piece_move_finished():
	piece_move_num += 1
	if piece_move_num == get_children().filter(func (c): return c is Piece).size():
		move_finished.emit()
