extends Node
class_name Lines

var line_scene = preload("res://scenes/line.tscn")


func tetromino_add_to_line(tetromino: Tetromino):
	for piece in tetromino.pieces as Array[Piece]:
		var line_arr = get_children().filter(func(c: Line): return not c.is_cleared and c.position_y == piece.position.y)
		var line
		if line_arr.size() == 0:
			line = line_scene.instantiate() as Line
			line.position_y = piece.position.y
			line.clear_done.connect(on_line_clear_done)
			add_child(line)
		else:
			line = line_arr[0]
		piece.reparent(line)
	update_exit_pieces()
	clear_full_line()


var need_clear_line_num = -1

func clear_full_line():
	var need_clear_lines = get_children().filter(func(c: Line): return c is Line and c.check_full()) as Array[Line]
	need_clear_line_num = need_clear_lines.size()
	need_clear_lines.sort_custom(func(c1: Line, c2: Line): return c1.position_y < c2.position_y)
	for line in need_clear_lines:
		line.clear()
		update_top_lines_pos_y(line)


# 检测所有应该清除的line被清除
func on_line_clear_done():
	need_clear_line_num -= 1
	if need_clear_line_num == 0:
		top_lines_move_down()
		update_exit_pieces()


func update_top_lines_pos_y(clear_line: Line):
	var top_lines = get_children().filter(func(c: Line): return c is Line and c.position_y < clear_line.position_y) as Array[Line]
	for top_line in top_lines:
		top_line.update_position_y()


func top_lines_move_down():
	for line in get_children().filter(func(c: Line): return c is Line and not c.is_cleared) as Array[Line]:
		line.move_down()


func update_exit_pieces():
	var pieces_all: Array[Piece] = []
	for line in get_children().filter(func(c: Line): return c is Line and not c.is_cleared):
		pieces_all.append_array(line.get_children().filter(func(c): return c is Piece))
	Global.pieces = pieces_all
