class_name Grid
extends Node2D

const SEPARATOR_WIDTH = 4

@export var height := 10
@export var width := 8

func _ready():
	generate_random_grid()

func _process(delta):
	pass

func generate_random_grid() -> void:
	for i in range(width):
		for j in range(height):
			var cell := SceneFactory.create_cell(Vector2i(i,j), SEPARATOR_WIDTH, _cell_clicked)

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

			add_child(cell)
			i += 1
	height = j

func get_cell(coordinates: Vector2i) -> Cell:
	return get_node_or_null("%s" % coordinates)

#TODO implement behavior when a cell is clicked
func _cell_clicked(cell: Cell) -> void:
	pass
