class_name GlobalTimer
extends Node3D

signal game_ended

const GAME_DURATION = 5 #300  # 5 minutes in seconds
var time_remaining: float = GAME_DURATION
var timer_active: bool = false
var end_animation: float = 0

@export var display_time: Label3D
@export var end_panel: Panel
@export var end_audio: AudioStreamPlayer


func _ready():
	reset_timer()
	end_panel.modulate = Color(1, 1, 1, 0)


func _process(delta):
	if timer_active:
		time_remaining -= delta
		time_remaining = max(time_remaining, 0)
		display_time.text = get_time_remaining_formatted()
		if time_remaining <= 0:
			end_game()
	elif time_remaining <= 0:
		end_animation += delta		
		var coefSplash = transition(end_animation, 0, 5, 2) #end_audio.stream.get_length()
		end_panel.modulate = Color(1, 1, 1, coefSplash)

func start_timer():
	timer_active = true


func pause_timer():
	timer_active = false


func reset_timer():
	time_remaining = GAME_DURATION
	timer_active = false


func end_game():
	timer_active = false
	game_ended.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	end_audio.play()
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://scenes/menu_end.tscn")


func get_time_remaining() -> float:
	return time_remaining


func get_time_remaining_formatted() -> String:
	var minutes = floori(time_remaining / 60)
	var seconds = floori(time_remaining) % 60
	var milliseconds = floori((time_remaining - floor(time_remaining)) * 1000)
	return "%01d:%02d.%03d" % [minutes, seconds, milliseconds]

func transition(t: float, start_time: float, duration: float, slope: float) -> float:
	var normalized_time = (t - start_time) / duration
	
	if normalized_time < 0.0:
		return 0.0
	elif normalized_time <= 1.0:
		return smoothstep(0.0, 1.0, normalized_time * slope)
	elif normalized_time <= 2.0:
		return 1.0 - smoothstep(0.0, 1.0, (normalized_time - 1.0) * slope)
	else:
		return 0.0
# Helper function to implement smoothstep, as it's not built-in to GDScript
func smoothstep(edge0: float, edge1: float, x: float) -> float:
	var t = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0)
	return t * t * (3.0 - 2.0 * t)
