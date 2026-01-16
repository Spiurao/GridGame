class_name Grid
extends Node2D

const SEPARATOR_WIDTH = 4

@export var height := 10
@export var width := 8

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_random_grid() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_random_grid() -> void:
	for i in range(width):
		for j in range(height):
			var cell := SceneFactory.create_cell(Vector2i(i,j), SEPARATOR_WIDTH, _cell_clicked)

			add_child(cell)

#TODO implement behavior when a cell is clicked
func _cell_clicked(cell: Cell) -> void:
	pass
