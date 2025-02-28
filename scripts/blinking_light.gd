extends OmniLight3D

@export var noise : Noise

# Called when the node enters the scene tree for the first time.
var time: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	time += delta * 0.1 
	var sampled_noise = noise.get_noise_1d(time)
	sampled_noise = abs(sampled_noise) 
	self.light_energy = min(sampled_noise , 1.0)
