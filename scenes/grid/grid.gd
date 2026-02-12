class_name Grid
extends Node2D

signal grid_is_changing

const SEPARATOR_WIDTH = 4

@export var height := 10
@export var width := 8

var cells : Array[Cell] = []

# idea : chain elements manually, the more the better
# to make the player link enemy elements, make it a threat : too many
# adjacent enemy elements will blow up (you get 1 turn to prevent that or something)

func _ready():
	generate_random_grid()
	cells.append_array(get_tree().get_nodes_in_group("cells")) # ew but no choice :/


func generate_random_grid() -> void:
	for i in range(width):
		for j in range(height):
			var cell := SceneFactory.create_cell(Vector2i(i,j), SEPARATOR_WIDTH, _cell_clicked)
			connect("grid_is_changing", cell._on_grid_change_set_accepts_inputs)

			add_child(cell)

func generate_grid_from_file(file_path):
	var file := FileAccess.open(file_path, FileAccess.READ)
	var content := file.get_as_text()
	var i := 0
	var j := 0
	for element_id in content:
		if element_id == '\n':
			width = i
			i = 0
			j += 1
		else:
			var cell := SceneFactory.create_cell_with_element(Vector2i(i,j), int(element_id),\
						SEPARATOR_WIDTH, _cell_clicked)
			connect("grid_is_changing", cell._on_grid_change_set_accepts_inputs)

			add_child(cell)
			i += 1
	height = j

func delete_same_type_adjacent_elements(coordinates: Vector2i, element_type: String,\
			visited: Dictionary) -> void:
	var cell := get_cell(coordinates)

	if cell and cell.get_element() and not visited.has(cell)\
		and cell.get_element().category == element_type:

		cell.delete_element()
		visited[cell] = true

		delete_same_type_adjacent_elements(coordinates + Vector2i(1,0), element_type, visited)
		delete_same_type_adjacent_elements(coordinates + Vector2i(-1,0), element_type, visited)
		delete_same_type_adjacent_elements(coordinates + Vector2i(0,1), element_type, visited)
		delete_same_type_adjacent_elements(coordinates + Vector2i(0,-1), element_type, visited)

func drop_elements() -> void:
	for i in range(width-1, -1, -1):
		for j in range(height-1, -1, -1):
			if get_cell(Vector2i(i,j)).is_empty():
				# Making all elements above fall down
				var k := j
				var empty_column_size := 0
				var found_element := false
				var found_next_empty_space := false

				var hanging_cell: Cell = null
				while k > 0 and not found_element: # checking if something needs to fall down
					k -= 1
					empty_column_size += 1
					hanging_cell = get_cell(Vector2i(i,k))
					found_element = not hanging_cell.is_empty()

					if found_element: # find the end of the block of elements that will fall
						var elements_block_size := 0
						var l: int

						# edge case where we check the element on top
						if k == 0:
							found_next_empty_space = true
							l = -1
						else:
							l = k

						# this logic is eventually repeated for
						# each block of elements separated
						# by spaces in the current column
						while l > 0 and not found_next_empty_space:
							l -= 1 #-1 so k-l = 1 meaning we have only the top element to move
							found_next_empty_space = get_cell(Vector2i(i,l)).is_empty()

						if found_next_empty_space or l == 0: # l=0 means we've reached the top
							elements_block_size = k-l
							for m in range(elements_block_size):
								get_cell(Vector2i(i,j-m))\
								.swap_elements(get_cell(Vector2i(i,j-empty_column_size-m)))

func get_cell(coordinates: Vector2i) -> Cell:
	if coordinates.x >= width or coordinates.x < 0:
		return null
	if coordinates.y >= height or coordinates.x < 0:
		return null
	
	return cells[coordinates.x * height + coordinates.y] # matrix projected in 1D array

func is_changing() -> bool:
	return cells.any(
			func(cell): return cell.get_element().is_moving if cell.get_element() else false)

#TODO implement behavior when a cell is clicked
func _cell_clicked(cell: Cell) -> void:
	delete_same_type_adjacent_elements(cell.coordinates, cell.get_element().category, {})
	await get_tree().process_frame #TODO delete (is for debugging purposes)
	drop_elements()
