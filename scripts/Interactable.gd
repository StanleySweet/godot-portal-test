class_name Interactable
extends StaticBody3D

signal interacted(body)

@export var prompt_message: String = "Interact"
@export var prompt_action: String = "interact"
@export var enabled: bool = true
@export var outlineMesh: MeshInstance3D
# @onready var audiostreamplayer : AudioStreamPlayer3D = $AudioStreamPlayer3D

var is_module: bool = false

func _ready() -> void:
	hide_outline()


func get_prompt():
	if not self.enabled:
		return ""

	var key_name = ""
	for action: InputEvent in InputMap.action_get_events(prompt_action):
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.physical_keycode)
	return prompt_message + "\n[" + key_name + "]"


func show_outline():
	if self.enabled:
		self.outlineMesh.visible = true
		#self.outlineMeshRed.visible = false
	else:
		self.outlineMesh.visible = false
		#self.outlineMeshRed.visible = true


func hide_outline():
	self.outlineMesh.visible = false
	#self.outlineMeshRed.visible = false


func interact(body):
	if self.enabled:
		#audiostreamplayer.play()
		interacted.emit(body)
