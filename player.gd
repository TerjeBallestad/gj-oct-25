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
		print("Mouse Motion at: ", event.position)


func _on_body_entered(_body):
	hit.emit()
