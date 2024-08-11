extends Node2D
class_name Piece

signal clear_done

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

func set_texture(texture: Texture):
	sprite_2d.texture = texture


func clear():
	animation_player.play('clear')


func handle_clear_done():
	clear_done.emit()
