extends Control


@onready var bt_play = %Play
@onready var bt_level = %Level
@onready var score_list_node = %VBoxContainer

var game_scene_path = "res://scenes/game.tscn"

func _ready():
	Global.level = 1
	bt_level.text = 'LEVEL: ' + str(Global.level)
	load_record_from_config()
	
func load_record_from_config():
	var list = Global.get_score_list_from_config_file()
	init_score_list(list)
	Global.score_list = list

func _on_play_pressed():
	get_tree().change_scene_to_file(game_scene_path)


func _on_level_pressed():
	Global.level = 5.0 if Global.level == 1.0 else (Global.level + 5.0)
	if Global.level > 25.0:
		Global.level = 1.0
	bt_level.text = 'LEVEL: ' + str(Global.level)


func init_score_list(list):
	for child in score_list_node.get_children():
		child.queue_free()
	
	for item in list:
		var nick_name = item.nick_name
		var score = item.score
		var label_name = Label.new()
		var label_score = Label.new()
		label_name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label_score.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label_score.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		label_name.text = nick_name
		label_score.text = str(score)
		var h_container = HBoxContainer.new()
		h_container.add_child(label_name)
		h_container.add_child(label_score)
		score_list_node.add_child(h_container)
	
