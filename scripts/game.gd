extends Node


@onready var score = $Score
@onready var level = $Level
@onready var lines = $Lines
@onready var tetromino_tip_next_1 = $TetrominoTipNext1
@onready var tetromino_tip_next_2 = $TetrominoTipNext2
@onready var tetromino_tip_next_3 = $TetrominoTipNext3
@onready var tetromino_tip_hold = $TetrominoTipHold


var tetrominos: Array[Tetromino] = []
var current_tetromino: Tetromino
var current_tetromino_type: Global.Tetromino = Global.Tetromino.values().pick_random()
var next_tetrominos_type: Array[Global.Tetromino] = []
var hold_tetromino_type: Global.Tetromino



const tetromino_scene = preload("res://scenes/tetromino.tscn")

func _ready():
	create_tetromino()
	init_next_tetrominos_type()


func init_next_tetrominos_type():
	for i in range(3):
		var type = Global.Tetromino.values().pick_random()
		next_tetrominos_type.append(type)
	update_tetromino_tip()


func update_tetrominos_type():
	current_tetromino_type = next_tetrominos_type[0]
	var new_type = Global.Tetromino.values().pick_random()
	next_tetrominos_type.remove_at(0)
	next_tetrominos_type.append(new_type)
	update_tetromino_tip()


func update_tetromino_tip():
	tetromino_tip_next_1.update_type(next_tetrominos_type[0])
	tetromino_tip_next_2.update_type(next_tetrominos_type[1])
	tetromino_tip_next_3.update_type(next_tetrominos_type[2])


func create_tetromino():
	current_tetromino = tetromino_scene.instantiate()
	add_child(current_tetromino)
	current_tetromino.other_tetrominos = tetrominos
	current_tetromino.locked.connect(on_tetromino_locked)
	current_tetromino.create(current_tetromino_type)


func on_tetromino_locked():
	print('game get tetromino locked')
	tetrominos.append(current_tetromino)
	update_tetrominos_type()
	create_tetromino()
