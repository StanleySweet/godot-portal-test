extends Node2D

@export var backButton: BaseButton
@export var clickPlayer: AudioStreamPlayer2D
@export var music: AudioStreamPlayer


func _ready() -> void:
	backButton.pressed.connect(self._backPressed)

func _backPressed():
	clickPlayer.play()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
