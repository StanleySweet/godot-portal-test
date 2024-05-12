extends Control

@onready var play_button: TextureButton = $Panel/Start/MarginContainer/CenterContainer/HBoxContainer/PlayButton
@onready var back_button: TextureButton = $Panel/Credits/MarginContainer/CenterContainer/HBoxContainer/BackButton
@onready var level1_button: TextureButton = $Panel/LevelSelect/MarginContainer/CenterContainer2/GricContainer/VBoxContainer/HBoxContainer/Level1
@onready var start: Control = $Panel/Start
@onready var credits: Control = $Panel/Credits
@onready var levels: Control = $Panel/LevelSelect

var level1 = preload("res://DemonsOnDemand/scenes/levels/level_one.tscn")
var level2 = preload("res://DemonsOnDemand/scenes/levels/level_two.tscn")
var level3 = preload("res://DemonsOnDemand/scenes/levels/level_three.tscn")
var level4 = preload("res://DemonsOnDemand/scenes/levels/level_four.tscn")

func _ready() -> void:
	play_button.grab_focus()

func _on_play_button_pressed() -> void:
	var start_tween = create_tween()
	start_tween.tween_property(start, "modulate", Color.TRANSPARENT, 0.5)
	levels.visible = true
	var levels_tween = create_tween()
	levels_tween.tween_property(levels, "modulate", Color.WHITE, 0.5)
	start.visible = false
	level1_button.grab_focus()

func _on_credits_button_pressed() -> void:
	var start_tween = create_tween()
	start_tween.tween_property(start, "modulate", Color.TRANSPARENT, 0.5)
	credits.visible = true
	var credits_tween = create_tween()
	credits_tween.tween_property(credits, "modulate", Color.WHITE, 0.5)
	start.visible = false
	back_button.grab_focus()

func _on_back_button_pressed() -> void:
	var credits_tween = create_tween()
	credits_tween.tween_property(credits, "modulate", Color.TRANSPARENT, 0.5)
	var levels_tween = create_tween()
	levels_tween.tween_property(levels, "modulate", Color.TRANSPARENT, 0.5)
	start.visible = true
	var start_tween = create_tween()
	start_tween.tween_property(start, "modulate", Color.WHITE, 0.5)
	credits.visible = false
	levels.visible = false
	play_button.grab_focus()

func _on_level_1_pressed():
	get_tree().change_scene_to_packed(level1)

func _on_level_2_pressed():
	get_tree().change_scene_to_packed(level2)
	
func _on_level_3_pressed():
	get_tree().change_scene_to_packed(level3)

func _on_level_4_pressed():
	get_tree().change_scene_to_packed(level4)
