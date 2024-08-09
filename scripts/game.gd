extends Node

signal record_score_change(val)
signal record_lines_change(val)


var line_scene = preload("res://scenes/line.tscn")
var tetromino_scene = preload("res://scenes/tetromino.tscn")

var current_tetromino: Tetromino
var current_tetromino_type: Global.Tetromino = Global.Tetromino.values().pick_random()
var next_tetrominos_type: Array[Global.Tetromino] = []

var hold_tetromino_type = null:
	set(val):
		if val != null:
			hold_tetromino_type = val
			tetromino_hold_tip.update_type(val)

var record_score = 0:
	set(val):
		record_score = val
		record_score_change.emit(val)
var record_lines = 0:
	set(val):
		record_lines = val
		record_lines_change.emit(val)

@onready var ghost_tetromino = $GhostTetromino
@onready var lines = $Lines
@onready var tetromino_next_tips = $TetrominoNextTips
@onready var tetromino_hold_tip = $TetrominoHoldTip


func _ready():
	init_tetromino()
	for i in range(3):
		var type = Global.Tetromino.values().pick_random()
		next_tetrominos_type.append(type)
	tetromino_next_tips.update_next_tetrominos_ui(next_tetrominos_type)


func _input(_event):
	if Input.is_action_just_pressed('hold'):
		toggle_hold_tetromino()


func toggle_hold_tetromino():
	if hold_tetromino_type == null:
		hold_tetromino_type = current_tetromino.type
		tetromino_hold_tip.visible = true
		var pos = current_tetromino.record_position
		current_tetromino.queue_free()
		update_current_and_next_tetromino_type()
		init_tetromino(pos)
	else:
		var type = hold_tetromino_type
		hold_tetromino_type = current_tetromino_type
		current_tetromino_type = type
		var pos = current_tetromino.record_position
		current_tetromino.queue_free()
		init_tetromino(pos)


func update_current_and_next_tetromino_type():
	current_tetromino_type = next_tetrominos_type[0]
	var new_type = Global.Tetromino.values().pick_random()
	next_tetrominos_type.remove_at(0)
	next_tetrominos_type.append(new_type)
	tetromino_next_tips.update_next_tetrominos_ui(next_tetrominos_type)


func init_tetromino(pos = null):
	current_tetromino = tetromino_scene.instantiate() as Tetromino
	current_tetromino.type = current_tetromino_type
	if pos != null:
		current_tetromino.record_position = pos as Vector2
	current_tetromino.tetromino_locked.connect(on_tetromino_locked)
	current_tetromino.tetromino_transformed.connect(ghost_tetromino.update_pieces)
	add_child(current_tetromino)
	


func update_exit_pieces():
	var pieces_all: Array[Piece] = []
	for line in lines.get_children().filter(func(c: Line): return not c.is_clear):
		pieces_all.append_array(line.get_children())
	Global.pieces = pieces_all


func tetromino_add_to_line(tetromino: Tetromino):
	for piece in tetromino.pieces:
		var line_arr = lines.get_children().filter(func(c): return c.position_y == piece.position.y)
		var line
		if line_arr.size() == 0:
			line = line_scene.instantiate() as Line
			lines.add_child(line)
			line.position_y = piece.position.y
		else:
			line = line_arr[0]
		piece.reparent(line)


func clear_full_line():
	for line in lines.get_children() as Array[Line]:
		var is_full = line.check_full()
		if is_full:
			record_lines += 1
			record_score += Global.level * 10
			line.clear()
			var top_lines = lines.get_children().filter(func(c: Line): return c is Line and not c.is_clear and c.position_y < line.position_y) as Array[Line]
			for top_line in top_lines:
				top_line.move_down()


func on_tetromino_locked():
	tetromino_add_to_line(current_tetromino)
	current_tetromino.queue_free()
	clear_full_line()
	update_exit_pieces()
	update_current_and_next_tetromino_type()
	init_tetromino()
