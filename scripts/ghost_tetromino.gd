extends Node2D
class_name GhostTetromino

@export var type: Global.Tetromino

var piece_scene = preload("res://scenes/piece.tscn")
var pieces: Array[Piece] = []

@onready var piece = $Piece
@onready var piece_2 = $Piece2
@onready var piece_3 = $Piece3
@onready var piece_4 = $Piece4

# 是否向下移动
var is_locked = false


func _ready():
	pieces = [piece, piece_2, piece_3, piece_4]
	visible = false


func update_pieces(tetromino: Tetromino):
	if not visible:
		visible = true
	type = tetromino.type
	var data = Global.data[type] as PieceData
	var texture = data.ghost_texture
	for i in range(pieces.size()):
		pieces[i].set_texture(texture)
		pieces[i].position = tetromino.pieces[i].position
	is_locked = false
	ghost_down()



func ghost_down():
	while not is_locked:
		move_down()


func move_down():
	set_pieces_pos(Vector2.DOWN)


func check_out_edge(pos: Vector2):
	if pos.x < Global.bound_min_x or pos.x > Global.bound_max_x or pos.y > Global.bound_max_y:
		return true
	return false


func check_colliding_with_other_piece(pos: Vector2):
	for other_piece in Global.pieces:
		if pos == other_piece.position:
			return true
	return false


func set_pieces_pos(param):
	var next_pieces_pos: Array[Vector2] = []
	
	for piece in pieces:
		var next_pos = piece.position + Global.grid_size * param
		next_pieces_pos.append(next_pos)
		if(check_colliding_with_other_piece(next_pos) or check_out_edge(next_pos)):
			next_pieces_pos.clear()
			is_locked = true
			break
		
	for i in range(next_pieces_pos.size()):
		pieces[i].position = next_pieces_pos[i]
