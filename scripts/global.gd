extends Node

signal level_change(val)

const rows = 20
const cols = 10
const size = 25
const grid_size = 26
enum Tetromino { I, L, J, S, Z, O, T }
var bound_min_x = 270
var bound_max_x = 530 - 26
var bound_max_y = 560 - 26
var tetromino_init_pos = Vector2(400, 40)

var level = 1


const piece_coords = {
	Tetromino.I: [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)],
	#-------------------------------------------------------------------
	Tetromino.J: [Vector2(1,1), Vector2(-1, 0), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	Tetromino.L: [Vector2(-1, 1), Vector2(-1, 0), Vector2(0,0), Vector2(1, 0 )],
	#-------------------------------------------------------------------
	Tetromino.O: [Vector2(0,1), Vector2(1,1), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	Tetromino.S: [Vector2(-1, 1), Vector2(0, 1), Vector2(0,0), Vector2(1, 0)],
	#-------------------------------------------------------------------
	Tetromino.T: [Vector2(0,1), Vector2(-1, 0), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	Tetromino.Z: [Vector2(0,1), Vector2(1,1), Vector2(-1, 0), Vector2(0,0)]
}

var data = {
	Tetromino.I: preload("res://Resources/i_piece_data.tres"),
	Tetromino.J: preload("res://Resources/j_piece_data.tres"),
	Tetromino.L: preload("res://Resources/l_piece_data.tres"),
	Tetromino.O: preload("res://Resources/o_piece_data.tres"),
	Tetromino.S: preload("res://Resources/s_piece_data.tres"),
	Tetromino.T: preload("res://Resources/t_piece_data.tres"),
	Tetromino.Z: preload("res://Resources/z_piece_data.tres")
}

var clockwise_rotation_matrix = Transform2D(Vector2(0, -1), Vector2(1, 0), Vector2(0, 0))
var counter_clockwise_rotation_matrix = Transform2D(Vector2(0,1), Vector2(-1, 0), Vector2(0, 0))

# 已经被锁定并未被消除的块
var pieces: Array[Piece] = []
