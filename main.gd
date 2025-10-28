extends Node

@export var gnome_scene: PackedScene
@export var block_scene: PackedScene
var score := 0
var current_block: CraftableBlock
var gnomes: Array[Gnome] = []
var blocks: Array[CraftableBlock] = []
var finished_blocks: Array[CraftableBlock] = []

func _ready():
	_new_game()

func _process(_delta):
	pass

func _on_player_hit():
	pass # Replace with function body.

func _game_over():
	$GnomeSpawnTimer.stop()

func _new_game():
	$StartTimer.start()
	score = 0


func _on_start_timer_timeout():
	spawn_blocks()
	current_block = blocks.pick_random()
	$GnomeSpawnTimer.start()

func _on_gnome_spawn_timer_timeout():
	var gnome: Gnome = gnome_scene.instantiate()
	var spawn_location = $SpawnPath/SpawnLocation
	spawn_location.progress_ratio = randf()
	gnome.position = spawn_location.position
	gnome.set_current_block(current_block)
	gnome.die.connect(gnomes.erase)
	gnomes.push_back(gnome)
	add_child(gnome)

func score_add(amount: float):
	score += int(amount)
	$HUD/PanelContainer/Label.text = str(score) + " points"

func score_set(amount: float):
	score = int(amount)
	$HUD/PanelContainer/Label.text = str(score) + " points"

func score_update(amount: float):
	score_set(finished_blocks.size() * 100 + amount)

func spawn_blocks():
	for i in 5:
		for j in 8:
			var block: CraftableBlock = block_scene.instantiate()
			block.position = Vector2(i * block.scale.x * 16 + 300 + i * 3, j * block.scale.y * 16 + 100 + j * 3)
			blocks.push_back(block)
			add_child(block)
			block.visibility_set(false)
			block.update_progress.connect(score_update)
			block.construction_complete.connect(finish_current_block)

func finish_current_block(current: CraftableBlock):
	finished_blocks.push_back(current)
	blocks.erase(current)
	current_block = blocks.pick_random()
	for gnome in gnomes:
		print(gnome.name)
		gnome.set_current_block(current_block)
	
