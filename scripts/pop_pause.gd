extends PanelContainer

@onready var pop_how_to_play = $"../PopHowToPlay"



func _on_how_to_play_pressed():
	pop_how_to_play.show()
