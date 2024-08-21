extends PanelContainer


@onready var score_list_node = $VBoxContainer/PanelContainer/VBoxContainer/ScoreList


func init_score_list():
	for child in score_list_node.get_children():
		child.free()
	for item in Global.score_list:
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
	
