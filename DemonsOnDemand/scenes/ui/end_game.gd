extends Panel

@onready var circles : Array[TextureRect] = [$EndGamePanel/Panel/LeftCircle, $EndGamePanel/Panel/MidCircle, $EndGamePanel/Panel/LateCircle]
@onready var dark : Panel = $Dark
@onready var BGPan : Panel = $BackgroundPanel
@onready var enjoyDem : RichTextLabel = $EndGamePanel/Panel/EnjoyDemons
@onready var Line : Panel = $Line
@onready var EndGamePanel = $EndGamePanel

@onready var back_button: TextureButton = $EndGamePanel/MarginContainer/CenterContainer/HBoxContainer2/BackButton

@export var star_texture : CompressedTexture2D

func activate_end_screen(score: int, stars: int):
	back_button.grab_focus()
	var dark_tween = create_tween()
	dark_tween.tween_property(dark, "modulate", Color.BLACK, 0.5)
	await get_tree().create_timer(0.8).timeout
	enjoyDem.text = "[center]Your customers enjoyed their demons.\nYou scored " + str(score) + " summonings points.[/center]"
	BGPan.visible = true
	Line.visible = true
	EndGamePanel.visible = true
	dark.visible = false
	for i in range(0, stars):
		circles[i].texture = star_texture
	await get_tree().create_timer(0.5).timeout
	var star2 = stars
	for circle in circles:
		var circle_tween = create_tween()
		circle_tween.tween_property(circle, "scale", Vector2(1,1), 0.6)
		await get_tree().create_timer(0.6).timeout
		if stars > 0:
			stars -= 1
			$Stamp.stop()
			$Stamp.seek(0.0)
			$Stamp.play()
	if star2 > 0:
		$DemLau.play()
	else:
		$Crickets.play()


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://DemonsOnDemand/scenes/ui/start_screen/start_screen.tscn")
