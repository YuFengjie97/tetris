extends Node2D
class_name Piece

@onready var sprite_2d = $Sprite2D

func set_texture(texture: Texture):
	sprite_2d.texture = texture
