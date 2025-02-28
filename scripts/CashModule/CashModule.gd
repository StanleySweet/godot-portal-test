class_name CashModule
extends ModuleInteractable

@onready var weel1: Node3D = $Weel_1
@onready var weel2: Node3D = $Weel_2
@onready var weel3: Node3D = $Weel_3
@onready var spinning_sound: AudioStreamPlayer = $SpinningSound
@onready var coins_sound: AudioStreamPlayer = $CoinsSound
@onready var break_machine_sound: AudioStreamPlayer = $BreakMachineSound
@onready var break_digicode_sound: AudioStreamPlayer = $BreakDigicodeSound

@onready var geiger_sound: AudioStreamPlayer = $GeigerSound

@export var duration: float = 4
@export var rotation_speed: float = 600
@export var acceleration_segments: float = 5
@export var predeterminate_min: int = 1
@export var predeterminate_max: int = 3

signal add_coins(amount: int)
signal break_cuve
signal break_leds
signal break_digicode

const RAND_DELTA: float = 1
const FACES: int = 10
const VALUES = [
	"Miss", "Coins", "Computer", "Cuve", "Coins", "Leds", "Miss", "Cuve", "Coins", "Digicode"
]
const PREDETERMINATES = [
	["Coins"],
	["Leds", "Cuve", "Miss"],
	["Coins", "Coins", "Coins", "Miss"],
	["Leds", "Digicode", "Cuve", "Miss", "Coins"],
	["Coins", "Miss"],
	["Leds", "Digicode", "Cuve"],
]

var elapsed_time: float = 0
var current_rotation_speed: float = 0
var running: bool = false
var run_count: int = 0
var prederminate_count: int = 0
var next_prederminate: int = 0
var target_value: String = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if running:
		elapsed_time += delta

		var first_segment_time = duration / acceleration_segments
		var last_segment_time = duration * ((acceleration_segments - 1) / acceleration_segments)

		if elapsed_time < duration:
			var ratio = 1
			if elapsed_time < first_segment_time:
				ratio = clampf(elapsed_time / first_segment_time, 0, 1)
			elif elapsed_time > last_segment_time:
				ratio = (1 - clampf((elapsed_time - last_segment_time) / first_segment_time, 0, 1))

			self.current_rotation_speed = rotation_speed * ratio + (360 / FACES)

	var weel1_ready = rotate_weel(weel1, delta)
	var weel2_ready = rotate_weel(weel2, delta)
	var weel3_ready = rotate_weel(weel3, delta)

	if weel1_ready and weel2_ready and weel3_ready:
		weels_over()


func rotate_weel(weel: Node3D, delta: float) -> bool:
	if running:
		if elapsed_time < duration:
			weel.rotation_degrees.x -= int(delta * get_rotation_speed())
			return false
		elif int(weel.rotation_degrees.x) % (360 / FACES) != 0:
			if target_value != "" and rotation_to_next_value(weel) != target_value:
				weel.rotation_degrees.x -= 5
			else:
				weel.rotation_degrees.x -= 1
			return false

		if target_value != "":
			var current_value = rotation_to_value(weel)
			if target_value != current_value:
				weel.rotation_degrees.x -= 1
				return false

		return true
	return false


func rotation_to_value(weel: Node3D) -> String:
	var rot = (int(-weel.rotation_degrees.x) % 360) / (360 / FACES)
	return VALUES[rot]


func rotation_to_next_value(weel: Node3D) -> String:
	var rot = (int(-weel.rotation_degrees.x) % 360) / (360 / FACES)
	var next_rot = rot + 1

	if next_rot == VALUES.size():
		next_rot = 0

	return VALUES[next_rot]


func get_rotation_speed() -> float:
	var rng = RandomNumberGenerator.new()
	return (
		current_rotation_speed
		+ rng.randf_range(-current_rotation_speed * RAND_DELTA, current_rotation_speed * RAND_DELTA)
	)


func start_weels() -> float:
	running = true
	elapsed_time = 0
	if not spinning_sound.playing:
		spinning_sound.play()

	# if run_count == next_prederminate:
	# 	#var rng = RandomNumberGenerator.new()
	# 	next_prederminate = run_count  # + rng.randi_range(predeterminate_min, predeterminate_max)
	# 	target_value = ""

	var rng = RandomNumberGenerator.new()
	var id = rng.randi_range(0, PREDETERMINATES[run_count % PREDETERMINATES.size()].size() - 1)
	target_value = PREDETERMINATES[run_count % PREDETERMINATES.size()][id]
	print("target %s" % target_value)

	run_count += 1

	return duration


func weels_over():
	spinning_sound.stop()
	var weel1_value = rotation_to_value(weel1)
	var weel2_value = rotation_to_value(weel2)
	var weel3_value = rotation_to_value(weel3)

	if weel1_value == weel2_value and weel2_value == weel3_value:
		if weel1_value == "Coins":
			add_coins.emit(100)
			coins_sound.play()
		elif weel1_value == "Cuve":
			break_cuve.emit()
			geiger_sound.play()
		elif weel1_value == "Leds":
			break_leds.emit()
			break_machine_sound.play()
		elif weel1_value == "Digicode":
			break_digicode.emit()
			break_digicode_sound.play()

	running = false
