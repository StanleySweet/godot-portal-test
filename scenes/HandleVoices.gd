extends Node3D

@export var voiceConfig: Array[AudioStreamPlayer]
@export var weekendVoice: AudioStreamPlayer

var texts = [
	"You know what's a good day of work ? A day without an incident, those happen sometimes.",
	"Well that shouldn't make take noise...",
	"Atomic Budget Cuts only selects the finest quality duct tape.",
	"If you ever see some goo near the reactor core, nothing to be afraid of...but don't drink it...or do it, who cares !?",
	"Nuclear Science ain't that complicated afterall, flipping some switches to make sure nothing goes wrong.",
	"Here at Atomic Budget Cuts we do science the way our pioneer did it back then, with our bare hands.",
	"Anyone needing any safety equipment is expected to fill in the SRR-12F3 form and send it to HR 2 weeks prior to usage. Any request out of these bounds will be rejected."
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var label = get_tree().get_root().get_node("Node3D/Room/Player/CanvasLayer/VoiceOver")
	label.text = "" # We reset the text
	triggerVoices()
	pass # Replace with function body.

func triggerVoices():
	await get_tree().create_timer(15.0).timeout
	var i = 0
	while true:
		if i >= voiceConfig.size():
			i = 0
		voiceConfig[i].play()
		var label = get_tree().get_root().get_node("Node3D/Room/Player/CanvasLayer/VoiceOver")
		label.text = texts[i]
		var soundDuration = 10 #voiceConfig[i].stream.get_length() + 3
		var DELAY_BETWEEN_SOUNDS = 30.0
		await get_tree().create_timer(soundDuration).timeout
		label.text = ""
		await get_tree().create_timer(clampf(DELAY_BETWEEN_SOUNDS - soundDuration, 0., DELAY_BETWEEN_SOUNDS)).timeout
		i += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
