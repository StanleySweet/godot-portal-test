class_name LedModule
extends Node3D

@export var list_of_buttons: Array[LedModuleButtonInteractable]
@export var list_of_leds: Array[LedModuleLight]

signal module_success(is_success: bool)

var leds_on: int = 0

var number_of_broken_leds: int = 0


func _ready() -> void:
	for led in list_of_leds:
		if led != null:
			led.turn_on_red_light()


func update_led_lights() -> void:
	for led in list_of_leds:
		led.turn_on_red_light()

	if leds_on == list_of_leds.size() and number_of_broken_leds == 0:
		module_success.emit(true)
	else:
		module_success.emit(false)

	for i in range(leds_on):
		if i < list_of_leds.size():
			list_of_leds[i].turn_on_green_light()
		else:
			list_of_leds[i % list_of_leds.size()].turn_on_red_light()


func on_button_pressed(leds_to_turn_on: int) -> void:
	leds_on += leds_to_turn_on
	update_led_lights()


func random_button_pressed(_nope) -> void:
	for i in range(list_of_buttons.size() * 2):
		list_of_buttons[randi_range(0, list_of_buttons.size()) - 1].interact(null)


func broke_random_led() -> void:
	var functional_leds = []
	for led in list_of_leds:
		if not led.is_broken:
			functional_leds.append(led)
	if functional_leds.size() > 0:
		var random_functional_led = functional_leds[randi_range(0, functional_leds.size() - 1)]
		random_functional_led.broke_light()
		number_of_broken_leds += 1
	update_led_lights()


func repair_random_led() -> void:
	var broken_leds = []
	for led in list_of_leds:
		if led.is_broken:
			broken_leds.append(led)
	if broken_leds.size() > 0:
		var random_broken_led = broken_leds[randi_range(0, broken_leds.size() - 1)]
		random_broken_led.repair_light()
		number_of_broken_leds -= 1
	update_led_lights()
