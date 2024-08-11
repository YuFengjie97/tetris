extends Node
class_name Lines

signal move_finished

var line_scene = preload("res://scenes/line.tscn")
var need_move_down_line_num = 0
var need_clear_line_num = 0
var need_move_lines = []:
	set(val):
		need_move_lines = val
		need_move_down_line_num = val.size()


func tetromino_add_to_lines(tetromino: Tetromino):
	for piece in tetromino.pieces as Array[Piece]:
		var line_arr = get_children().filter(func(c: Line): return c.pos_y == piece.position.y) as Array[Line]
		var line = line_scene.instantiate() as Line
		if line_arr.size() == 0:
			line.pos_y = piece.position.y
			line.clear_finished.connect(_on_line_clear_finished)
			line.move_finished.connect(_on_line_move_finished)
			add_child(line)
		else:
			line = line_arr[0]
		line.add_piece(piece)
	update_exit_pieces()
	clear_full_line()


func clear_full_line():
	var need_clear_lines = get_children().filter(func(c: Line): return c is Line and c.check_full()) as Array[Line]
	need_clear_line_num = need_clear_lines.size()
	need_clear_lines.sort_custom(func(c1: Line, c2: Line): return c1.pos_y < c2.pos_y)
	for line in need_clear_lines:
		line.clear()
		update_need_move_line_pos_y(line)
		
	if need_clear_line_num == 0:
		move_finished.emit()


# 检测所有应该清除的line被清除
func _on_line_clear_finished():
	print_debug('_on_line_clear_finished')
	need_clear_line_num -= 1
	if need_clear_line_num == 0:
		lines_move_down()
		update_exit_pieces()


func update_need_move_line_pos_y(line: Line):
	var top_lines = get_children().filter(func(c: Line): return c is Line and not c.is_cleared and c.pos_y < line.pos_y) as Array[Line]
	need_move_lines = top_lines
	for top_line in top_lines:
		top_line.set_pos_y_by_move_down()


func lines_move_down():
	print('lines_move_down')
	for line in need_move_lines:
		line.move_down()


func _on_line_move_finished():
	need_move_down_line_num -= 1
	if need_move_down_line_num == 0:
		move_finished.emit()


func update_exit_pieces():
	var pieces_all: Array[Piece] = []
	for line in get_children().filter(func(c: Line): return c is Line and not c.is_cleared):
		pieces_all.append_array(line.get_children().filter(func(c): return c is Piece))
	Global.pieces = pieces_all
