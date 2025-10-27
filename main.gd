extends Node

@export var gnome_scene: PackedScene
@export var block_scene: PackedScene
var score := 0
var current_block: CraftableBlock

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
	current_block = $CraftableBlock
	score = 0
	_on_gnome_spawn_timer_timeout()

func _on_start_timer_timeout():
	$GnomeSpawnTimer.start()

func _on_gnome_spawn_timer_timeout():
	var gnome = gnome_scene.instantiate()
	var spawn_location = $SpawnPath/SpawnLocation
	spawn_location.progress_ratio = randf()
	gnome.position = spawn_location.position
	gnome.set_current_block(current_block)
	add_child(gnome)
	current_block.connect("area_entered", start_crafting)

func start_crafting(gnome: Gnome):
	gnome.start_construction()
	gnome.construct_block.connect(score_add.bind(randf() * 10))

func score_add(amount: int):
	score += amount
	$HUD/PanelContainer/Label.text = str(score) + " points"
	print(score)
