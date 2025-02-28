extends Area3D

@export var MaxAngle : float = 1.0
@onready var player = $"../../../../Player"
@onready var camera = $"../../SubViewport/Cameras/TCAM"

func _on_area_body_entered(body):	
	var angle: float = Vector3.LEFT.angle_to(player.position)
	if angle < self.MaxAngle and body.is_in_group("player"):
		var camera_pos: Vector3 = camera.global_position 
		body.global_position = camera_pos
