extends OmniLight3D

@export var noise : Noise

# Called when the node enters the scene tree for the first time.
var time: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta 
	var sampled_noise = noise.get_noise_1d(time)
	sampled_noise = abs(sampled_noise) 
	self.light_energy = min(sampled_noise * 100.0, 10.0)
