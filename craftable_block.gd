extends Node2D
class_name CraftableBlock

@onready var sprite_node = $Sprite2D
@onready var collision_shape = $CollisionShape2D

var progress := 0.0 # 0-1
signal construction_complete(block: CraftableBlock)
signal update_progress(progress: float)

func construction(amount: float):
	progress = clampf(amount + progress, 0, 1)
	visibility_set(true)
	sprite_node.set_instance_shader_parameter("progress", progress)
	#var color = progress / 100
	#color_set(Color(color, color, color))
	update_progress.emit(progress)
	if progress == 1:
		construction_complete.emit(self)

func visibility_set(visibility: bool):
	sprite_node.visible = visibility

func color_set(color: Color):
	sprite_node.modulate = color
