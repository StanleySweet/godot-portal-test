extends Node2D

@export var panelSplash: Panel
@export var panelMenu: Panel
@export var panelTeam: Panel
@export var buttonStart: BaseButton
@export var buttonStaff: BaseButton
@export var buttonBack: BaseButton
@export var clickPlayer: AudioStreamPlayer2D
@export var music: AudioStreamPlayer


var _time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panelMenu.hide()
	panelTeam.hide()
	
	buttonStart.pressed.connect(self._startPressed)
	buttonStaff.pressed.connect(self._staffPressed)
	buttonBack.pressed.connect(self._backPressed)

	pass # Replace with function body.

var startTime = -1

func _startPressed():
	clickPlayer.play()
	startTime = _time
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/room.tscn")
	pass

func _staffPressed():
	clickPlayer.play()
	panelTeam.show()

func _backPressed():
	clickPlayer.play()
	panelTeam.hide()

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time += delta
	var coefSplash = transition(_time, 2, 10, 2)
	panelSplash.modulate = Color(coefSplash, coefSplash, coefSplash)

	var startMenu = 20.0;
	if _time > startMenu:
		panelMenu.show()
	var coefMenu = clampf(_time-startMenu, 0.0, 1.0)	
	if startTime > 0:
		var coef = 1.0-clampf((_time-startTime)*0.5, 0, 1)
		coefMenu = coef
		music.volume_db = lerp(-80, 0, coef);
	panelMenu.modulate = Color(coefMenu, coefMenu, coefMenu)
	pass
