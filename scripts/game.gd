extends Node


@onready var score = $Score
@onready var level = $Level
@onready var lines = $Lines


const tetromino_scene = preload("res://scenes/tetromino.tscn")

func _ready():
	create_tetromino()


func create_tetromino():
	var type = Global.Tetromino.values().pick_random()
	var tetromino = tetromino_scene.instantiate()
	add_child(tetromino)
	tetromino.create(type)
	
	
