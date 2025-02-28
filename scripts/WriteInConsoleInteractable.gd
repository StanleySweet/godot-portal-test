class_name WriteInConsoleInteractable
extends Interactable

@export var interaction_message : String

func _ready() -> void:
	super.hide_outline()
	prompt_message = "Write in console"

func interact(body):
	if enabled:
		super.interact(body)
		print("[Console Interaction] ", interaction_message)
