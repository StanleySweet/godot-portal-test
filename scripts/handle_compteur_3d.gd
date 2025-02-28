extends Node3D

var min_angle = 30.8
var max_angle = -22.1

@export var compteur_module: CompteurModuleDisplay
var pivotJauge: Node3D

func set_percent(percent: float):
	pivotJauge.rotation_degrees.z = lerp(min_angle, max_angle, clampf(percent, 0., 1.))
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	compteur_module = get_parent()
	pivotJauge = $PivotJauge
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	set_percent(compteur_module.value/1000.0)
	pass
