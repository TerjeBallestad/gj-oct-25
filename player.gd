extends Area2D

@export var speed = 400
var screen_size
signal hit

func _ready():
	screen_size = get_viewport_rect().size

func _process(_delta):
	pass

func _input(event):
	if event is InputEventMouseMotion:
		position = event.position


func _on_body_entered(_body):
	hit.emit()


func _on_area_entered(area):
	print(area.name)
	if area is Gnome:
		area.flee()


func _on_area_exited(area):
	if area is Gnome:
		area.undo_flee()
