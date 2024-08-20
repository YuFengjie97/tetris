extends Control


@onready var bt_play = $Play
@onready var bt_level = $Level
@onready var score_list = $PanelContainer/MarginContainer/VBoxContainer

var game_scene_path = "res://scenes/game.tscn"

func _ready():
	init_score_list()
	bt_level.text = 'LEVEL: ' + str(Global.level)


func _on_play_pressed():
	get_tree().change_scene_to_file(game_scene_path)


func _on_level_pressed():
	Global.level = 5.0 if Global.level == 1.0 else (Global.level + 5.0)
	if Global.level > 25.0:
		Global.level = 1.0
	bt_level.text = 'LEVEL: ' + str(Global.level)


func init_score_list():
	for child in score_list.get_children():
		child.queue_free()
	var list = [
		{'nickname': 'a', 'score': 1},
		{'nickname': 'aa', 'score': 111},
		{'nickname': 'aaaaaa', 'score': 111111},
	]
	
	for item in list:
		var nickname = item.nickname
		var score = item.score
		var label_name = Label.new()
		var label_score = Label.new()
		label_name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label_score.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label_score.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		label_name.text = nickname
		label_score.text = str(score)
		var h_container = HBoxContainer.new()
		h_container.add_child(label_name)
		h_container.add_child(label_score)
		score_list.add_child(h_container)
	
