class_name NumpadModule
extends Node3D

@export var displaySequnce: Label3D
@export var list_of_leds: Array[NumpadModuleLight]
@export var list_of_buttons: Array[NumpadModuleButtonInteractable]

signal module_success(is_success: bool)

var value_sequence: String = ""
var number_of_broken_buttons: int = 0

var solution1 = "1495"
var solution2 = "3990"
var solution3 = "7430"
var solution4 = "3141"
var solution5 = "2528"

var isSolution1Found: bool = false
var isSolution2Found: bool = false
var isSolution3Found: bool = false
var isSolution4Found: bool = false
var isSolution5Found: bool = false


func _ready() -> void:
	reset()


func on_button_pressed(pad_value: int) -> void:
	value_sequence += str(pad_value)
	displaySequnce.text = value_sequence

	if value_sequence == solution1:
		isSolution1Found = true
		list_of_leds[0].turn_on_green_light()
	if value_sequence == solution2:
		isSolution2Found = true
		list_of_leds[1].turn_on_green_light()
	if value_sequence == solution3:
		isSolution3Found = true
		list_of_leds[2].turn_on_green_light()
	if value_sequence == solution4:
		isSolution4Found = true
		list_of_leds[3].turn_on_green_light()
	if value_sequence == solution5:
		isSolution5Found = true
		list_of_leds[4].turn_on_green_light()

	if (
		isSolution1Found
		and isSolution2Found
		and isSolution3Found
		and isSolution4Found
		and isSolution5Found
	):
		module_success.emit(true)
	else:
		module_success.emit(false)

	if value_sequence.length() == 4:
		value_sequence = ""


func reset() -> void:
	value_sequence = ""
	displaySequnce.text = value_sequence
	isSolution1Found = false
	isSolution2Found = false
	isSolution3Found = false
	isSolution4Found = false
	isSolution5Found = false
	for led in list_of_leds:
		led.turn_on_red_light()


func broke_random_button() -> void:
	var functional_buttons = []
	for button in list_of_buttons:
		if not button.is_broken:
			functional_buttons.append(button)
	if functional_buttons.size() > 0:
		var random_functional_button = functional_buttons[randi_range(
			0, functional_buttons.size() - 1
		)]
		random_functional_button.broke_button()
		number_of_broken_buttons += 1


func repair_random_button() -> void:
	var broken_buttons = []
	for button in list_of_buttons:
		if button.is_broken:
			broken_buttons.append(button)
	if broken_buttons.size() > 0:
		var random_broken_button = broken_buttons[randi_range(0, broken_buttons.size() - 1)]
		random_broken_button.repair_button()
		number_of_broken_buttons -= 1
