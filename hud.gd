extends CanvasLayer

signal start_game(level: int)
signal retry_level()
signal go_to_level_select()

const timmy_scared_1 = preload("res://sprites/people/timmy_scared_1.png")
const timmy_scared_2 = preload("res://sprites/people/timmy_scared_2.png")
const timmy_scared_3 = preload("res://sprites/people/timmy_scared_3.png")
const timmy_scared_4 = preload("res://sprites/people/timmy_scared_4.png")
const timmy_scared_5 = preload("res://sprites/people/timmy_scared_5.png")


func show_score(points: float, available_points: float, gnomes: int):
	var tween = create_tween()
	%ScoreCard.show()
	%StarTexture1.modulate = Color.BLACK
	%StarTexture2.modulate = Color.BLACK
	%StarTexture3.modulate = Color.BLACK
	%StarTexture4.modulate = Color.BLACK
	%StarTexture5.modulate = Color.BLACK
	%GnomeCount.text = "0"
	%TotalScore.text = "0"
	
	tween.tween_method(set_label_text.bind(%BaseScore), 0, points * 10.0, 1.0)
	var percentage = points / available_points

	%VictimFace.show()
	%VictimFace.modulate = Color.TRANSPARENT
	%VictimFace.texture = timmy_scared_1
	if percentage > 0.1:
		tween.tween_method(set_visible_stars, 0, 1, 1.0)
	if percentage > 0.4:
		tween.tween_method(set_visible_stars, 0, 2, 1.0)
		%VictimFace.texture = timmy_scared_2
	if percentage > 0.7:
		tween.tween_method(set_visible_stars, 0, 3, 1.0)
		%VictimFace.texture = timmy_scared_3
	if percentage > 0.85:
		tween.tween_method(set_visible_stars, 0, 4, 1.0)
		%VictimFace.texture = timmy_scared_4
	if percentage > 0.95:
		tween.tween_method(set_visible_stars, 0, 5, 1.0)
		%VictimFace.texture = timmy_scared_5
	tween.tween_method(set_label_text.bind(%GnomeCount), 0, gnomes, 1.0)
	var total = int(points * 10) * gnomes
	tween.tween_method(set_label_text.bind(%TotalScore), 0, total, 1.0)
	tween.tween_property(%VictimFace, "modulate", Color.WHITE, 1.0)

func set_label_text(number: float, label: Label):
	label.text = "%d" % number

func set_visible_stars(count: int):
	if count > 0:
		%StarTexture1.modulate = Color.WHITE
	if count > 1:
		%StarTexture2.modulate = Color.WHITE
	if count > 2:
		%StarTexture3.modulate = Color.WHITE
	if count > 3:
		%StarTexture4.modulate = Color.WHITE
	if count > 4:
		%StarTexture5.modulate = Color.WHITE

func _on_victim_1_button_pressed():
	start_game.emit(1)

func _on_victim_2_button_pressed():
	start_game.emit(2)

func _on_victim_3_button_pressed():
	start_game.emit(3)

func _on_victim_4_button_pressed():
	start_game.emit(4)

func _on_victim_5_button_pressed():
	start_game.emit(5)

func _on_retry_button_pressed():
	retry_level.emit()

func _on_level_select_button_pressed():
	go_to_level_select.emit()


func _on_instruction_start_button_pressed():
	%InstructionPanel.hide()
	retry_level.emit()
