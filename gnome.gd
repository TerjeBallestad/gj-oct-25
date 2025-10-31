extends Area2D
class_name Gnome

@export var speed := 150

enum States { CONSTRUCTING, FLEEING, WALKING }
var state: States = States.WALKING

signal construct_block
signal die(victim: Gnome)

var current_block: CraftableBlock
var current_destination: Vector2
var pickaxe_frams: Array[int] = [2]

func start_construction():
	state = States.CONSTRUCTING
	$ConstructionTimer.start()
	rotation = position.direction_to(current_destination).angle() + PI * 1.5
	$AnimatedSprite2D.play("working")
	$AnimatedSprite2D.flip_h = false
	$AnimatedSprite2D.flip_v = false

func set_current_block(block: CraftableBlock):
	state = States.WALKING
	current_block = block
	set_destination(block.position)

func set_destination(destination: Vector2):
	rotation = PI * -0.25
	current_destination = destination
	if current_destination.x > position.x:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	if current_destination.y > position.y:
		$AnimatedSprite2D.flip_v = false
	else:
		$AnimatedSprite2D.flip_v = true
	$AnimatedSprite2D.play("walk")

func flee():
	if state == States.FLEEING:
		return
	$GraceTimer.start()
	$AnimatedSprite2D.play("caught")

func undo_flee():
	$GraceTimer.stop()
	if state == States.WALKING:
		$AnimatedSprite2D.play("walk")
	if state == States.CONSTRUCTING:
		$AnimatedSprite2D.play("working")

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
	set_destination(transform.x.normalized() * 4000)
	die.emit(self)
	state = States.FLEEING
	$AnimatedSprite2D.play("fleeing")

func _on_area_entered(area: Area2D):
	if current_block.name == area.name:
		start_construction()


func _on_sprite_frame_changed():
	if $AnimatedSprite2D.animation == "working" && $AnimatedSprite2D.frame in pickaxe_frams:
		%PickaxeSFX.pitch_scale = 1 + randf() * 0.2
		%PickaxeSFX.play(0.29)
	
