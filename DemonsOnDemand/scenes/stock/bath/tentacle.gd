extends Node

@export var max_y: float = 0.2
@export var min_y: float = -0.2
@export var speed: float = 0.2

var _direction: int = 1

func _process(delta):
	self.position = Vector3(0, self.position.y + speed * _direction * delta, 0)

	if(self.position.y > max_y || self.position.y < min_y):
		_direction *= -1
