extends ColorRect



@export var min_angle = 132.6
@export var max_angle = 224.1
@export var base_speed = 2.0
@export var erratic_factor = 0.5
@export var direction_change_chance = 0.5

var current_angle = min_angle
var velocity = 1.0
var direction = 1

func _physics_process(delta):
	var speed = base_speed + randf() * erratic_factor * base_speed
	
	if randf() < direction_change_chance:
		direction *= -1
	
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	var time = Time.get_ticks_msec() * 0.001
	var noise_value = noise.get_noise_1d(time)
	
	var target_angle = lerp(min_angle, max_angle, (sin(time * speed) + noise_value + 1) / 2)
	
	var angle_diff = (target_angle - current_angle) * direction
	velocity += angle_diff * delta * 10.0
	velocity *= 0.95 + randf() * 0.1
	
	current_angle += velocity
	current_angle = clamp(current_angle, min_angle, max_angle)
	rotation_degrees = current_angle
