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
@onready var board = $Board
@onready var tetromino_next_tips = $TetrominoNextTips
@onready var tetromino_hold_tip = $TetrominoHoldTip
@onready var ui_score = $ui/Score
@onready var ui_level = $ui/Level
@onready var ui_lines = $ui/Lines
@onready var audio_hard_drop = $HardDrop
@onready var audio_move = $Move
@onready var audio_rotate = $Rotate
@onready var audio_line_clear = $LineClear
@onready var audio_hold = $Hold
@onready var pop_pause = $PanelContainer
@onready var loading = $Loading


func _ready():
	ui_level.text = str(Global.level)
	board.move_finished.connect(_on_lines_move_finished)
	init_tetromino()
	for i in range(3):
		var type = Global.Tetromino.values().pick_random()
		next_tetrominos_type.append(type)
	tetromino_next_tips.update_next_tetrominos_ui(next_tetrominos_type)


func _input(_event):
	if Input.is_action_just_pressed('hold'):
		toggle_hold_tetromino()
		audio_hold.play()


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
	if current_tetromino:
		current_tetromino.queue_free()
	
	current_tetromino = tetromino_scene.instantiate() as Tetromino
	
	current_tetromino.tetromino_hard_drop.connect(play_audio_hard_drop)
	current_tetromino.move.connect(play_audio_move)
	current_tetromino.rotate.connect(play_audio_rotate)
	
	current_tetromino.type = current_tetromino_type
	if pos != null:
		current_tetromino.record_position = pos as Vector2
	current_tetromino.tetromino_locked.connect(_on_tetromino_locked)
	current_tetromino.tetromino_transformed.connect(ghost_tetromino.update_pieces)
	add_child(current_tetromino)


func play_audio_hard_drop():
	audio_hard_drop.play()

func play_audio_move():
	audio_move.play()

func play_audio_rotate():
	audio_rotate.play()


func _on_tetromino_locked():
	ghost_tetromino.visible = false
	board.tetromino_add_to_lines(current_tetromino)
	update_current_and_next_tetromino_type()


func _on_lines_move_finished():
	init_tetromino()


func _on_board_line_clear():
	audio_line_clear.play()


func _on_resume_pressed():
	pop_pause.visible = false
	loading.loading()


func _on_pause_pressed():
	get_tree().paused = true
	pop_pause.visible = true
