extends Node2D

@onready var label = $Label
@onready var animation_player = $AnimationPlayer


func handle_tree_start():
	get_tree().paused = false


func loading():
	animation_player.play('loading')
