class_name CustomTimer
extends Control

signal timer_elapsed

enum DIRECTION { UP, DOWN }

@onready var current_time_label: RichTextLabel = $Panel/CurrentTimeLabel

@export var duration: int = 60
@export var direction: DIRECTION = DIRECTION.DOWN
@export var show_ui: bool = true

var is_enabled = true
var is_paused: bool = false
var current_time: float = 0
var config: Config

@export var is_global: bool = false

func _ready() -> void:
	config = get_tree().get_first_node_in_group("Config")
	if config == null:
		printerr("No Config found. Please add a config node to the scene and add it to the config group.")
	duration = config.global_timer_duration
	reset_timer(is_paused)
	current_time_label.visible = show_ui

func _process(delta: float) -> void:
	if not is_enabled or is_paused:
		return

	current_time += delta
	current_time_label.text = format_time(current_time)
	if current_time >= duration:
		timer_elapsed.emit()
		is_enabled = false

func reset_timer(paused: bool = false) -> void:
	is_enabled = true
	is_paused = paused
	current_time = 0
	current_time_label.text = format_time(current_time)

func format_time(time: float) -> String:
	var remaining_time = time
	match direction:
		DIRECTION.DOWN:
			remaining_time = duration - time

	var minutes: int = remaining_time / 60
	var seconds: int = int(fmod(remaining_time, 60))
	return str("%0*d" % [2, minutes]) + ":" + str("%0*d" % [2, seconds])
