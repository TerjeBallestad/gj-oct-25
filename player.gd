extends Area2D

func _process(_delta):
	pass

func _input(event):
	if event is InputEventMouseMotion:
		position = event.position

func _on_area_entered(area):
	if area is Gnome:
		area.flee()

func _on_area_exited(area):
	if area is Gnome:
		area.undo_flee()
