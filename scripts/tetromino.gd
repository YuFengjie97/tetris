extends Node2D
class_name Tetromino

var piece_scene = preload("res://scenes/piece.tscn")
var pieces = []
var record_position = Vector2(400, 40)
var type: Global.Tetromino = Global.Tetromino.I
var lock = false


func create(tetromino_type: Global.Tetromino):
	type = tetromino_type
	var data = Global.data[type]
	var texture = data.texture
	var piece_coords = Global.piece_coords[type]
	for piece_coord in piece_coords:
		var piece = piece_scene.instantiate() as Piece
		pieces.append(piece)
		add_child(piece)
		piece.set_texture(texture)
		piece.position = record_position + Global.grid_size * piece_coord


func _input(_event):
	if Input.is_action_just_pressed('left'):
		move(Vector2.LEFT)
	if Input.is_action_just_pressed('right'):
		move(Vector2.RIGHT)
	if Input.is_action_just_pressed('down'):
		move(Vector2.DOWN)
	if Input.is_action_just_pressed('clockwise'):
		rotate_tetromino(true)
	if Input.is_action_just_pressed('counter_clockwise'):
		rotate_tetromino(false)


func move(direction: Vector2):
	if lock:
		return
	record_position += Global.grid_size * direction
	for piece in pieces:
		piece.position += Global.grid_size * direction


func rotate_tetromino(is_clockwise: bool):
	if type == Global.Tetromino.O:
		return
	var rotate_matrix = Global.clockwise_rotation_matrix if is_clockwise else Global.counter_clockwise_rotation_matrix
	# 对于坐标旋转，先平移到原点，再旋转，再平移到原来位置
	for piece in pieces:
		var piece_position = piece.position
		piece_position -= record_position
		piece.position = piece_position * rotate_matrix + record_position


func _on_timer_timeout():
	pass
	#move(Vector2.DOWN)
