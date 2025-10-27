extends Node

@export var gnome_scene: PackedScene
@export var block_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_player_hit():
	pass # Replace with function body.

func _game_over():
	$GnomeSpawnTimer.stop()

func _new_game():
	score = 0


func _on_start_timer_timeout():
	$GnomeSpawnTimer.start()

func _on_gnome_spawn_timer_timeout():
	var gnome = gnome_scene.instantiate()
	var spawn_location = $SpawnPath/SpawnLocation
	spawn_location.progress_ratio = randf()
	gnome.position = spawn_location.position
	gnome.set_destination($CraftableBlock)
	add_child(gnome)
