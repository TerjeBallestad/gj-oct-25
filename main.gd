extends Node

@export var gnome_scene: PackedScene
@export var block_scene: PackedScene
@export var scary_sprite1: Texture2D

enum States { TITLE, LEVEL_SELECT, INSTRUCTIONS, GAME, GAME_OVER, GAME_WIN }
var state: States = States.TITLE

var score := 0
var current_block: CraftableBlock
var gnomes: Array[Gnome] = []
var blocks: Array[CraftableBlock] = []
var finished_blocks: Array[CraftableBlock] = []


func _ready():
	_new_game()

func _process(_delta):
	pass

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
	var columns := 3
	var rows := 4
	var texture_size = scary_sprite1.get_size()
	var tile_size = Vector2(	texture_size.x / columns, texture_size.y / rows)
	var offset = Vector2(400, 100)
	print(texture_size, " ", tile_size)
	for i in columns:
		for j in rows:
			var block: CraftableBlock = block_scene.instantiate()
			var position = Vector2(i, j) * tile_size
			block.position = position + offset + Vector2(i * 3, j * 3)
			var region = Rect2(position, tile_size)
			blocks.push_back(block)
			add_child(block)
			var sprite = block.sprite_node
			sprite.region_enabled = true
			sprite.region_rect = region
			sprite.texture = scary_sprite1
			block.collision_shape.shape.set_size(tile_size)
			#block.visibility_set(false)
			block.update_progress.connect(score_update)
			block.construction_complete.connect(finish_current_block)

func finish_current_block(current: CraftableBlock):
	finished_blocks.push_back(current)
	blocks.erase(current)
	current_block = blocks.pick_random()
	for gnome in gnomes:
		print(gnome.name)
		gnome.set_current_block(current_block)
	
