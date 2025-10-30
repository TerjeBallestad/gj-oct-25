extends Node

@export var gnome_scene: PackedScene
@export var block_scene: PackedScene
@export var scary_sprite1: Texture2D

@onready var player = %player
@onready var start_timer = $StartTimer
@onready var gnome_timer = $GnomeSpawnTimer
@onready var hud = %HUD

enum States { TITLE, LEVEL_SELECT, INSTRUCTIONS, GAME, GAME_STARTING, GAME_OVER, GAME_WIN }
var state: States = States.TITLE

var score := 0
var current_level := 0
var current_block: CraftableBlock
var gnomes: Array[Gnome] = []
var blocks: Array[CraftableBlock] = []
var finished_blocks: Array[CraftableBlock] = []

func set_state(new_state: States):
	match new_state:
		States.TITLE:
			pass
		States.LEVEL_SELECT:
			%VictimMenu.show()
		States.GAME_STARTING:
			start_timer.start()
			score = 0
		States.GAME:
			spawn_blocks()
			current_block = blocks.pick_random()
			add_child(player)
			gnome_timer.start()
		States.GAME_OVER:
			gnome_timer.stop()
			remove_child(player)
			%GameOverMenu.show()
		States.GAME_WIN:
			gnome_timer.stop()
			remove_child(player)
			hud.show_score(score, 4*3*100, gnomes.size())
	state = new_state

func _ready():
	remove_child(player)
	set_state(States.LEVEL_SELECT)

func _process(_delta: float):
	if state == States.GAME && Input.is_action_pressed("finish_game"):
		set_state(States.GAME_WIN)

func _on_start_timer_timeout():
	set_state(States.GAME)

func _on_gnome_spawn_timer_timeout():
	var gnome: Gnome = gnome_scene.instantiate()
	var spawn_location = $SpawnPath/SpawnLocation
	spawn_location.progress_ratio = randf()
	gnome.position = spawn_location.position
	gnome.set_current_block(current_block)
	gnome.die.connect(remove_gnome)
	gnomes.push_back(gnome)
	update_gnome_label()
	add_child(gnome)

func remove_gnome(gnome: Gnome):
	gnomes.erase(gnome)
	update_gnome_label()

func score_add(amount: float):
	score += int(amount)
	%ScoreLabel.text = str(score) + " points"

func score_set(amount: float):
	score = int(amount)
	%ScoreLabel.text = str(score) + " points"

func update_gnome_label():
	print(gnomes.size())
	%GnomeCountLabel.text = str(gnomes.size()) + " gnomes"

func score_update(amount: float):
	score_set(finished_blocks.size() * 100 + amount)

func spawn_blocks():
	var columns := 3
	var rows := 4
	var texture_size = scary_sprite1.get_size()
	var tile_size = Vector2(	texture_size.x / columns, texture_size.y / rows)
	var offset = Vector2(400, 100)
	
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
			block.update_progress.connect(score_update)
			block.construction_complete.connect(finish_current_block)

func finish_current_block(current: CraftableBlock):
	finished_blocks.push_back(current)
	blocks.erase(current)
	if blocks.size() == 0:
		set_state(States.GAME_OVER)
		return
	current_block = blocks.pick_random()
	for gnome in gnomes:
		gnome.set_current_block(current_block)

func _on_hud_start_game(level: int):
	current_level = level
	%VictimMenu.hide()
	%GameOverMenu.hide()
	%ScoreCard.hide()
	set_state(States.GAME_STARTING)

func _on_hud_retry_level():
	_on_hud_start_game(current_level)
