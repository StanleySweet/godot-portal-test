class_name Score
extends Control

@onready var score_label: RichTextLabel = $Panel/RichTextLabel
var scoreManager : Node = null

func _ready():
	_retrieve_score_manager()

func _process(_delta: float) -> void:
	score_label.text = str("", scoreManager.current_score)

func _retrieve_score_manager():
	scoreManager = get_tree().get_first_node_in_group("ScoreManager")
	if scoreManager == null:
		printerr("No scoreManager found. Please add a scoreManager node to the scene and add it to the ScoreManager group.")
