extends Node

var best_score = 10
var score = 0
var lines = 0
var level_arr = [1, 5, 10, 15, 20, 25]
var level = level_arr[0]
var level_ind: int:
	set(value):
		level_ind = value
		level = level_arr[value % level_arr.size()]


const rows = 20
const cols = 10
const size = 25
const grid_size = 26


enum Tetromino { I, L, J, S, Z, O, T }

const piece_coords = {
	Tetromino.I: [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)],
	#-------------------------------------------------------------------
	Tetromino.J: [Vector2(-1, 1), Vector2(-1, 0), Vector2(0,0), Vector2(1, 0 )],
	#-------------------------------------------------------------------
	Tetromino.L: [Vector2(1,1), Vector2(-1, 0), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	Tetromino.O: [Vector2(0,1), Vector2(1,1), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	Tetromino.S: [Vector2(0,1), Vector2(1,1), Vector2(-1, 0), Vector2(0,0)],
	#-------------------------------------------------------------------
	Tetromino.T: [Vector2(0,1), Vector2(-1, 0), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	Tetromino.Z: [Vector2(-1, 1), Vector2(0, 1), Vector2(0,0), Vector2(1, 0)]
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
