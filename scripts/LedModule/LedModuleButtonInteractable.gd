class_name LedModuleButtonInteractable
extends OnOffButtonInteractable

signal led_module_button_pressed(leds_to_turn_on: int)

@export var leds_to_turn_on: int = 1


func _ready() -> void:
	super._ready()
	prompt_message = "Toggle LED Button"


func interact(body) -> void:
	if enabled:
		super.interact(body)
		led_module_button_pressed.emit(leds_to_turn_on if button_active else -leds_to_turn_on)
