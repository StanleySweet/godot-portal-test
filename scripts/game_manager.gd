extends Node

@export var global_timer: GlobalTimer

var led_module_success: bool = false
var numpad_module_success: bool = false
var compteur_module_success: bool = false
var cuve_module_success: bool = false

@onready var success_sound: AudioStreamPlayer = $SuccessSound

var cuve_module_score: int = 100

var game_ended: bool = false


func _ready():
	start_game()


func set_led_module_success(success: bool):
	if not led_module_success and success:
		success_sound.play()
		Input.action_press("escape")
	led_module_success = success
	stop_game_if_all_modules_success()


func set_numpad_module_success(success: bool):
	if not numpad_module_success and success:
		success_sound.play()
		Input.action_press("escape")
	numpad_module_success = success
	stop_game_if_all_modules_success()


func set_compteur_module_success(success: bool):
	if not compteur_module_success and success:
		success_sound.play()
		Input.action_press("escape")
	compteur_module_success = success
	stop_game_if_all_modules_success()


func set_cuve_module_success(success: bool):
	if not cuve_module_success and success:
		success_sound.play()
		Input.action_press("escape")
	cuve_module_success = success
	stop_game_if_all_modules_success()


func set_cuve_module_score(score: int):
	cuve_module_score = score


func stop_game_if_all_modules_success() -> void:
	if (
		not game_ended
		and led_module_success
		and numpad_module_success
		and compteur_module_success
		and cuve_module_success
	):
		end_game()


func start_game():
	global_timer.start_timer()
	game_ended = false


func end_game():
	game_ended = true
	print("Success: ", led_module_success, numpad_module_success, compteur_module_success)
	print("Cuve level: ", cuve_module_score)
	print("Time remaining: ", global_timer.get_time_remaining_formatted())
