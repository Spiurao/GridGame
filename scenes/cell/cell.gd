class_name Cell
extends Node2D

signal cell_clicked

var coordinates : Vector2i
var input_disabled := false
var element : Element

func _ready():
	add_to_group("cells")

func initialize(coord: Vector2i, separation_offset: int, _on_clicked_callback: Callable) -> void:
	var random_element := SceneFactory.generate_random_element()
	initialize_with_element(coord, random_element, separation_offset, _on_clicked_callback)

func initialize_with_element(coord: Vector2i, el: Element, separation_offset: int,\
			_on_clicked_callback: Callable) -> void:
	connect("cell_clicked", _on_clicked_callback)

	# Offset position within grid
	position = coord * (SceneFactory.SPRITE_SIZE + separation_offset)

	coordinates = coord
	el.name = "Element"

	add_child(el)
	element = el

func get_element() -> Element:
	return element

func delete_element() -> void:
	$Element.queue_free()
	element = null

func is_empty() -> bool:
	return element == null

## Swaps two elements and triggers the movement animation
func swap_elements(cell: Cell) -> void:
	var old_element := get_element()
	var new_element := cell.get_element()

	if new_element:
		cell.remove_child(new_element)
		add_child(new_element)
		# moving it back to the old position so it doesn't teleport
		new_element.global_position = cell.global_position
		new_element.move_to(global_position)
	if old_element:
		remove_child(old_element)
		cell.add_child(old_element)
		old_element.global_position = global_position
		old_element.move_to(cell.global_position)

	element = new_element
	cell.element = old_element

func _on_grid_change_set_accepts_inputs(value: bool) -> void:
	input_disabled = value

func _on_area_2d_input_event(_viewport, event, _shape_idx) -> void:
	if not input_disabled:
		if event.is_action_pressed("click") and get_element():
			emit_signal("cell_clicked", self)
