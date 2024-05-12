class_name RequestPanel
extends Panel

@export var request: RequestTemplate = RequestTemplate.new()
@export var request_duration: int = 60
@export var first_line: String
@export var second_line: String

@onready var progress_bar: ProgressBar = $VBoxContainer/Top/MarginContainer/MarginContainer/VBoxContainer/ProgressBar
@onready var text: RichTextLabel = $VBoxContainer/Top/MarginContainer/MarginContainer/VBoxContainer/Text
@onready var timer: CustomTimer = $Timer
@onready var ingredients_row: IngredientsRow = $VBoxContainer/Bottom/CenterContainer/IngredientsRow

var scoreManager : Node = null

var rng = RandomNumberGenerator.new()
var current_progress: float = 0
var is_enabled: bool = false

var ingredients_to_grab: Array[Config.INGREDIENTS] = []
func activate(availableIngredients):
	ingredients_to_grab = []
	var max_ingredient_to_grab = availableIngredients.size()
	if availableIngredients.has(Config.INGREDIENTS.HORNS) and availableIngredients.has(Config.INGREDIENTS.HORN):
		max_ingredient_to_grab -= 1
	var numb_ind_to_grab = rng.randi_range(1, max_ingredient_to_grab)
	var availables = availableIngredients.duplicate(true)
	while ingredients_to_grab.size() < numb_ind_to_grab:
		var ingredient = availables.pick_random()
		# you cannot get both horns at the same time
		match ingredient:
			Config.INGREDIENTS.HORN:
				if ingredients_to_grab.find(Config.INGREDIENTS.HORNS) > -1:
					continue
			Config.INGREDIENTS.HORNS:
				if ingredients_to_grab.find(Config.INGREDIENTS.HORN) > -1:
					continue

		if ingredients_to_grab.find(ingredient) > -1:
			continue

		ingredients_to_grab.append(ingredient)
		availables.pop_at(availables.find(ingredient))

	ingredients_row.set_ingredients(ingredients_to_grab)

	print(str("Ingredients to grab: ", ingredients_to_grab))

	visible = true
	is_enabled = true
	current_progress = 0
	timer.reset_timer()
	scoreManager.track_request(self)

func set_values(first: String, second: String, duration: int) -> void:
	first_line = first
	second_line = second
	request_duration = duration
	set_up(first_line, second_line, request_duration)

func _ready() -> void:
	_retrieve_score_manager()
	if timer:
		timer.connect("timer_elapsed", request_timeout)

func _process(delta: float) -> void:
	if not is_enabled:
		return

	current_progress += delta

	if current_progress > request_duration:
		return

	progress_bar.value = 100 - ((current_progress / request_duration) * 100)

func _retrieve_score_manager():
	scoreManager = get_tree().get_first_node_in_group("ScoreManager")
	if scoreManager == null:
		printerr("No scoreManager found. Please add a scoreManager node to the scene and add it to the ScoreManager group.")

func request_timeout():
	if not timer.is_enabled:
		return
	print("timeout!")
	scoreManager.handle_request_unfinished(self)
	finish()

func finish():
	visible = false
	is_enabled = false
	current_progress = 0
	timer.is_enabled = false

func set_up(first: String, second: String, duration: int):
	text.text = str("[center][b]", first.to_upper(), "[/b]\n", second, "[/center]")
	timer.duration = duration
	var fill: StyleBoxFlat = progress_bar.get_theme_stylebox("fill").duplicate()
	fill.set("bg_color", request.inner_color)
	fill.set("border_color", request.outer_color)
	progress_bar.add_theme_stylebox_override("fill", fill)
	ingredients_row.set_request_template(request)
