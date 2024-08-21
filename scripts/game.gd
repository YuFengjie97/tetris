extends Node


var line_scene = preload("res://scenes/line.tscn")
var tetromino_scene = preload("res://scenes/tetromino.tscn")

var current: Tetromino
var current_type: Global.Tetromino
var next_types: Array[Global.Tetromino] = []
var hold_type: Global.Tetromino:
	set(val):
		hold_type = val
		hold_tip.update_type(val)

var record_score = 0.0:
	set(val):
		record_score = val
		ui_score.text = str(val)
var record_lines = 0.0:
	set(val):
		record_lines = val
		ui_lines.text = str(val)
var record_level = Global.level:
	set(val):
		record_level = val
		Global.level = val
		ui_level.text = str(val)
@onready var board = $Board
@onready var next_tips = $TetrominoNextTips
@onready var hold_tip = $TetrominoHoldTip
@onready var ui_score = $ui/Score
@onready var ui_level = $ui/Level
@onready var ui_lines = $ui/Lines
@onready var audio_hold = $Hold
@onready var pop_pause = $PopPause
@onready var loading = $Loading
@onready var pop_game_over = $PopGameOver
@onready var pop_record = $PopRecord
@onready var your_score = $PopRecord/VBoxContainer/MarginContainer2/YourScore


func _ready():
	reset()


func reset():
	Global.pieces.clear()
	for line in board.get_node("Lines").get_children():
		line.free()
	for tetromino in board.get_children().filter(func(c): return c is Tetromino):
		tetromino.free()
	current = null
	init()
	init_current()
	board.min_y_line = 10000
	record_level = Global.level
	record_lines = 0
	record_score = 0
	

func init():
	ui_level.text = str(Global.level)
	if not board.action_finished.is_connected(on_board_action_finished):
		board.action_finished.connect(on_board_action_finished)
	current_type = Global.Tetromino.values().pick_random()
	for i in range(3):
		var type = Global.Tetromino.values().pick_random()
		next_types.append(type)
	next_tips.update_next_tetrominos_ui(next_types)


func _input(_event):
	if Input.is_action_just_pressed('hold'):
		switch_hold_current()
		audio_hold.play()


func switch_hold_current():
	if not current:
		return
	if not hold_tip.visible:
		hold_type = current.type
		hold_tip.update_type(hold_type)
		hold_tip.visible = true
		var pos = current.record_position
		set_current_from_next()
		init_current(pos)
	else:
		var type = hold_type
		hold_type = current_type
		hold_tip.update_type(hold_type)
		current_type = type
		var pos = current.record_position
		init_current(pos)


func set_current_from_next():
	current_type = next_types[0]
	var new_type = Global.Tetromino.values().pick_random()
	next_types.remove_at(0)
	next_types.append(new_type)
	next_tips.update_next_tetrominos_ui(next_types)


func init_current(pos = null):
	print_debug('init_current')
	if current:
		current.free()
	current = tetromino_scene.instantiate() as Tetromino
	board.add_child(current)
	current.init(current_type, pos)
	current.tetromino_locked.connect(on_current_locked)


func on_current_locked(tetromino: Tetromino):
	print_debug('on_current_locked')
	current = null
	set_current_from_next()
	board.tetromino_add_to_lines(tetromino)


func on_board_action_finished(clear_num):
	print('on_board_action_finished')
	record_score += clear_num * record_level * 10
	record_lines += 1
	init_current()


func _on_resume_pressed():
	pop_pause.hide()
	loading.loading()


func _on_pause_pressed():
	get_tree().paused = true
	pop_pause.show()

func _on_board_game_over():
	get_tree().paused = true
	var is_have_new_record = Global.score_list.any(func (e): return record_score > e.score)
	if is_have_new_record:
		your_score.text = 'Your Score: ' + str(record_score)
		pop_record.show()
	else:
		pop_game_over.init_score_list()
		pop_game_over.show()


var start_scene = preload("res://scenes/start.tscn")

func _on_home_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(start_scene)


func _on_level_up_timeout():
	print_debug('level_up')
	record_level = (record_level + 1.0) if record_level < 25.0 else 25.0
	if current:
		current.update_speed_timer_by_level()

func _on_score_up_timeout():
	record_score += record_level * 10


func _on_again_pressed():
	pop_game_over.hide()
	get_tree().paused = false
	reset()


func _on_pop_record_save_ok():
	_on_home_pressed()
