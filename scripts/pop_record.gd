extends PanelContainer

signal save_ok
@onready var line_edit = $VBoxContainer/HBoxContainer/LineEdit
@onready var game = $".."



func _on_name_confirm_pressed():
	var nick_name = line_edit.text as String
	var score = game.record_score
	if nick_name == '':
		return
	
	var score_list = []
	score_list.append({"nick_name": nick_name, "score": score})
	score_list.append_array(Global.get_score_list_from_config_file())
	
	score_list.sort_custom(func(a, b): return a.score > b.score)
	score_list = score_list.slice(0, 5)
	var config = ConfigFile.new()
	for item in score_list:
		config.set_value(item.nick_name, "score", item.score)
	
	var err = config.save("user://save.cfg")
	if err == OK:
		save_ok.emit()
