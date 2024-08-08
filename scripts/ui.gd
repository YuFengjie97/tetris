extends Node

@onready var score = $Score
@onready var level = $Level
@onready var lines = $Lines


func _ready():
	Global.level_change.connect(_on_level_change)

func _on_level_change(val):
	print('level-change')
	level.text = str(val)

func _on_game_record_lines_change(val):
	lines.text = str(val)


func _on_game_record_score_change(val):
	score.text = str(val)
