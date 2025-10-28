extends Node2D
class_name CraftableBlock

var progress := 0.0 # 0-100
signal construction_complete(block: CraftableBlock)
signal update_progress(progress: float)

func construction(amount: float):
	progress = clampf(amount + progress, 0, 100)
	visibility_set(true)
	var color = progress / 100 * -1 + 1
	color_set(Color(color, color, color))
	update_progress.emit(progress)
	if progress == 100:
		construction_complete.emit(self)

func visibility_set(visibility: bool):
	$Sprite2D.visible = visibility

func color_set(color: Color):
	$Sprite2D.modulate = color
