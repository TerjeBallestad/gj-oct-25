extends Area2D
class_name Gnome

@export var speed := 150

enum States { CONSTRUCTING, FLEEING, WALKING }
var state: States = States.WALKING

signal construct_block
signal die(victim: Gnome)

var current_block: CraftableBlock
var current_destination: Vector2

func start_construction():
	state = States.CONSTRUCTING
	$ConstructionTimer.start()

func set_current_block(block: CraftableBlock):
	state = States.WALKING
	current_block = block
	set_destination(block.position)

func set_destination(destination: Vector2):
	rotate(position.direction_to(destination).angle())
	current_destination = destination

func flee():
	if state == States.FLEEING:
		return
	$GraceTimer.start()

func undo_flee():
	$GraceTimer.stop()

func _ready():
	$AnimatedSprite2D.play("walk")

func _process(delta: float):
	if state in [States.WALKING, States.FLEEING]:
		position = position.move_toward(current_destination, speed * delta)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_construction_timer_timeout():
	if state == States.CONSTRUCTING:
		current_block.construction(maxf(0.01, randf() * 0.1))
		construct_block.emit()

func _on_grace_timer_timeout():
	rotate(PI)
	set_destination(transform.x.normalized() * 4000)
	die.emit(self)
	state = States.FLEEING

func _on_area_entered(area: Area2D):
	if current_block.name == area.name:
		start_construction()
