extends Node

@onready var tetromino_tip_next_1 = $TetrominoTipNext1
@onready var tetromino_tip_next_2 = $TetrominoTipNext2
@onready var tetromino_tip_next_3 = $TetrominoTipNext3


func update_next_tetrominos_ui(types: Array[Global.Tetromino]):
	tetromino_tip_next_1.update_type(types[0])
	tetromino_tip_next_2.update_type(types[1])
	tetromino_tip_next_3.update_type(types[2])
	
