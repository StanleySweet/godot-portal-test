class_name TimerBar extends TextureProgressBar

signal timer_elapsed

var timer_duration = 0
var elapsed_time = 0

func _ready():
	reset()

func _process(delta):
	if not visible:
		return

	elapsed_time += delta
	value = (elapsed_time / timer_duration) * 100

	if elapsed_time >= timer_duration:
		reset()
		timer_elapsed.emit()

func set_timer(time):
	timer_duration = time
	visible = true

func reset():
	visible = false
	timer_duration = 0
	elapsed_time = 0
