extends CanvasLayer

signal start_game(level: int)
signal retry_level()
signal go_to_level_select()

func show_score(points: float, available_points: float, gnomes: int):
	%ScoreCard.show()
	%BaseScore.text = "%d" % (points * 10.0)
	var percentage = points / available_points
	%StarTexture1.modulate = Color.BLACK
	%StarTexture2.modulate = Color.BLACK
	%StarTexture3.modulate = Color.BLACK
	%StarTexture4.modulate = Color.BLACK
	%StarTexture5.modulate = Color.BLACK
	
	if percentage > 0.1:
		%StarTexture1.modulate = Color.WHITE
	if percentage > 0.4:
		%StarTexture2.modulate = Color.WHITE
	if percentage > 0.7:
		%StarTexture3.modulate = Color.WHITE
	if percentage > 0.85:
		%StarTexture4.modulate = Color.WHITE
	if percentage > 0.95:
		%StarTexture5.modulate = Color.WHITE
	
	%GnomeCount.text = str(gnomes)
	var total = int(points * 10) * gnomes
	%TotalScore.text = "%d" % total
	
	

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
