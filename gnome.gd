extends Area2D
class_name Gnome

signal construct_block
@export var SPEED := 50
var current_block: CraftableBlock
var current_destination: Vector2
var block_reached := false
var scared := false

func start_construction():
	block_reached = true
	$ConstructionTimer.start()

func set_current_block(block: CraftableBlock):
	block_reached = false;
	current_block = block
	set_destination(block.position)

func set_destination(destination: Vector2):
	rotate(position.direction_to(destination).angle())
	current_destination = destination

func flee():
	if scared:
		return
	$GraceTimer.start()

func undo_flee():
	$GraceTimer.stop()

func _ready():
	pass

func _process(delta):
	if (current_block && !block_reached) || scared:
		position = position.move_toward(current_destination, SPEED * delta)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_construction_timer_timeout():
	if !scared:
		construct_block.emit()



func _on_grace_timer_timeout():
	rotate(PI)
	set_destination(transform.x.normalized() * 4000)
	scared = true
