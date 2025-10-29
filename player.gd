extends Area2D

const LightTexture = preload("res://sprites/scary/light.png")
const GRID_SIZE = 20
@export var fog: Sprite2D

var display_width = ProjectSettings.get("display/window/size/viewport_width")
var display_height = ProjectSettings.get("display/window/size/viewport_height")

var fogImage = Image.new()
var fogTexture = ImageTexture.new()
var lightImage = LightTexture.get_image()
var lightOffset = Vector2(lightImage.get_width() / 2.0, lightImage.get_height() / 2.0)

func _ready():
	print(display_width, " ", display_height)
	var fog_image_width = display_width / GRID_SIZE
	var fog_image_height = display_height / GRID_SIZE
	fogImage = Image.create(fog_image_width + 1, fog_image_height + 1, false, Image.FORMAT_RGBAH)
	lightImage.resize(16, 16)
	lightImage.convert(Image.FORMAT_RGBAH)
	fog.scale *= GRID_SIZE
	update_fog(get_local_mouse_position() / GRID_SIZE)

func update_fog(new_grid_position: Vector2):
	var light_rect = Rect2(Vector2.ZERO, Vector2(lightImage.get_width(), lightImage.get_height()))
	fogImage.fill(Color.BLACK)
	
	fogImage.blend_rect(lightImage, light_rect, new_grid_position - lightOffset)
	update_fog_image_texture()
	
func update_fog_image_texture():
	fogTexture = ImageTexture.create_from_image(fogImage)
	fog.texture = fogTexture

func _process(_delta):
	pass

func _input(event):
	if event is InputEventMouseMotion:
		position = event.position 
		update_fog(event.position / GRID_SIZE)

func _on_area_entered(area):
	if area is Gnome:
		area.flee()

func _on_area_exited(area):
	if area is Gnome:
		area.undo_flee()
