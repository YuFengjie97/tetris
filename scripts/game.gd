extends Node


@onready var score = $Score
@onready var level = $Level
@onready var lines = $Lines

var tetrominos: Array[Tetromino] = []
var current_tetromino: Tetromino


const tetromino_scene = preload("res://scenes/tetromino.tscn")

func _ready():
	create_tetromino()


func create_tetromino():
	var current_type = Global.Tetromino.values().pick_random()
	current_tetromino = tetromino_scene.instantiate()
	add_child(current_tetromino)
	current_tetromino.other_tetrominos = tetrominos
	current_tetromino.locked.connect(on_tetromino_locked)
	current_tetromino.create(current_type)


func on_tetromino_locked():
	print('game get tetromino locked')
	tetrominos.append(current_tetromino)
	create_tetromino()
