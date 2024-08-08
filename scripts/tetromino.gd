extends Node2D
class_name Tetromino

signal locked

var piece_scene = preload("res://scenes/piece.tscn")
var pieces: Array[Piece] = []

# 整个形状的位置，也作为初始生成位置
var record_position = Vector2(400, 40) 

# 在外部节点指定类型后，再初始化
var type: Global.Tetromino = Global.Tetromino.I

var is_locked = false

@export var other_pieces: Array[Piece] = [] 


# 边界坐标
var min_x = 270
var max_x = 530 - 26
var max_y = 560 - 26

func _ready():
	init_pieces()


func _input(_event):
	if is_locked:
		return
	if Input.is_action_just_pressed('left'):
		translate_tetromino(Vector2.LEFT)
	if Input.is_action_just_pressed('right'):
		translate_tetromino(Vector2.RIGHT)
	if Input.is_action_just_pressed('down'):
		translate_tetromino(Vector2.DOWN)
	if Input.is_action_just_pressed('clockwise'):
		rotate_tetromino(true)
	if Input.is_action_just_pressed('counter_clockwise'):
		rotate_tetromino(false)
	if Input.is_action_just_pressed('drop'):
		hard_drop()


func init_pieces():
	var data = Global.data[type]
	var texture = data.texture
	var piece_coords = Global.piece_coords[type]
	for piece_coord in piece_coords:
		var piece = piece_scene.instantiate() as Piece
		pieces.append(piece)
		add_child(piece)
		piece.set_texture(texture)
		# 指定位置时，piece按照指定位置生成
		piece.position = record_position + Global.grid_size * piece_coord


func update_type(tetromino_type: Global.Tetromino):
	type = tetromino_type
	init_pieces()


func translate_tetromino(direction: Vector2):
	if is_locked:
		return
	set_pieces_pos(direction)


func rotate_tetromino(is_clockwise: bool):
	if type == Global.Tetromino.O or is_locked:
		return
	var rotate_matrix = Global.clockwise_rotation_matrix if is_clockwise else Global.counter_clockwise_rotation_matrix
	set_pieces_pos(rotate_matrix)


func hard_drop():
	while(not is_locked):
		translate_tetromino(Vector2.DOWN)


func check_out_edge(pos: Vector2):
	if pos.x < min_x or pos.x > max_x or pos.y > max_y:
		return true
	return false


func check_colliding_with_other_piece(pos: Vector2):
	for other_piece in other_pieces:
		if pos == other_piece.position:
			return true
	return false


# 旋转&平移重叠判断，如果没有重叠，返回块位置
# param 可以是Vector/Transform2D，分别代表平移时的方向和旋转时的矩阵
func set_pieces_pos(param):
	var is_translate = param is Vector2
	var next_pieces_pos: Array[Vector2] = []
	
	for piece in pieces:
		var next_pos
		
		if is_translate:
			next_pos = piece.position + Global.grid_size * param
		else:
			# 对于坐标旋转，先平移到原点，再旋转，再平移到原来位置
			var piece_position_copy = piece.position - record_position
			next_pos = piece_position_copy * param + record_position
		next_pieces_pos.append(next_pos)
		
		
		if(check_out_edge(next_pos) or check_colliding_with_other_piece(next_pos)):
			next_pieces_pos.clear()
			break
		
	# 进行平移时更新形状位置
	if next_pieces_pos.size() > 0 and is_translate:
		record_position += Global.grid_size * param
	
	# 平移锁定
	if next_pieces_pos.size() == 0 and is_translate and param == Vector2.DOWN:
		is_locked = true
		locked.emit()
		
	for i in range(next_pieces_pos.size()):
		pieces[i].position = next_pieces_pos[i]


func _on_timer_timeout():
	pass
	#translate_tetromino(Vector2.DOWN)
