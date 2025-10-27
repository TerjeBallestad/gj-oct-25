extends RigidBody2D

signal construct_block
@export var SPEED := 50
var current_block: CraftableBlock

func start_construction():
	$ConstructionTimer.start()

func set_destination(block: CraftableBlock):
	current_block = block
	rotate(position.direction_to(block.position).angle())

func _ready():
	pass 

func _process(delta):
	if current_block:
		position += position.direction_to(current_block.position) * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_construction_timer_timeout():
	construct_block.emit()


func _on_body_entered(_body: Area2D):
	print(_body.name)
