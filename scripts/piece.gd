extends Node2D
class_name Piece

signal clear_finished
signal move_finished

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

func set_texture(texture: Texture):
	sprite_2d.texture = texture


func clear():
	animation_player.play('clear')


func handle_clear_finished():
	clear_finished.emit()


func move(pos_y: int):
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'position:y', pos_y, 0.1)
	await tween.finished
	move_finished.emit()
