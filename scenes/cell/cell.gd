class_name Cell
extends Node2D

signal cell_clicked

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

func get_element() -> Element:
	return get_node_or_null("Element")

func delete_element() -> void:
	$Element.queue_free()
	is_empty = true


func _on_area_2d_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click") and get_element():
		emit_signal("cell_clicked", self)
