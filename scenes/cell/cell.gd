class_name Cell
extends Node2D

var coordinates : Vector2i
var is_empty := true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(coord: Vector2i, separation_offset: int, _on_clicked_callback: Callable) -> void:
	var element := SceneFactory.generate_random_element()
	initialize_with_element(coord, element, separation_offset, _on_clicked_callback)

func initialize_with_element(coord: Vector2i, element: Element, separation_offset: int,\
			_on_clicked_callback: Callable) -> void:
	connect("cell_clicked", _on_clicked_callback)

	# Offset position within grid
	position = coord * (SceneFactory.SPRITE_SIZE + separation_offset)

	coordinates = coord
	element.name = "Element"

	is_empty = false
	add_child(element)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
