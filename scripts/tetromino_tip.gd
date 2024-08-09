extends Node2D
class_name TetrominoTip


var type: Global.Tetromino
var piece_scene = preload("res://scenes/piece.tscn")
var pieces: Array[Piece] = []

func _ready():
	update_type(Global.Tetromino.I)


func update_type(tetromino_type: Global.Tetromino):
	var childs = get_children()
	for child in childs:
		child.queue_free()
	type = tetromino_type
	var data = Global.data[type] as PieceData
	var texture = data.texture
	var piece_coords = Global.piece_coords[type]
	var offset = -data.center
	for piece_coord in piece_coords:
		var piece = piece_scene.instantiate() as Piece
		pieces.append(piece)
		add_child(piece)
		piece.set_texture(texture)
		piece.position = (piece_coord + offset) * Global.grid_size
		

