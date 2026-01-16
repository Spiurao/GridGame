extends Node

const CELL_SCENE = preload("res://scenes/cell/Cell.tscn")
const ELEMENT_SCENE = preload("res://scenes/element/Element.tscn")
const ELEMENT_SPRITES = preload("res://assets/textures/sprites.png")
const SPRITE_SIZE = 32

#TODO Move elements to their own config file
const ELEMENTS = [
	{"category": "PlayerPhysicalAttack"},
	{"category": "PlayerMagicalAttack"},
	{"category": "PlayerDefense"},
	{"category": "EnemyAttack"},
]

var rng := RandomNumberGenerator.new()
var sprite_number: int = ELEMENT_SPRITES.get_width()/SPRITE_SIZE

func generate_random_element() -> Element :
	# Chooses element at random
	var chosen_value := rng.randi_range(0, sprite_number - 1)
	var element := ELEMENT_SCENE.instantiate()

	element.category = ELEMENTS[chosen_value]["category"]

	#TODO change this logic when working with the actual sprites file
	var element_sprite := element.get_node("Sprite")
	element_sprite.texture = ELEMENT_SPRITES
	element_sprite.region_rect.position.x = chosen_value * SPRITE_SIZE

	return element

func get_element_from_id(id: int) -> Element :
	var element := ELEMENT_SCENE.instantiate()

	element.category = ELEMENTS[id]["category"]

	var element_sprite := element.get_node("Sprite")
	element_sprite.texture = ELEMENT_SPRITES
	element_sprite.region_rect.position.x = id * SPRITE_SIZE

	return element

func create_cell(coord: Vector2i, separation_offset: int,\
			_on_clicked_callback: Callable) -> Cell:
	var cell := CELL_SCENE.instantiate()
	cell.name = "%s" % coord
	cell.initialize(coord, separation_offset, _on_clicked_callback)

	return cell

func create_cell_with_element(coord: Vector2i, element_id: int,\
			separation_offset: int, _on_clicked_callback: Callable) -> Cell:
	var cell := CELL_SCENE.instantiate()
	cell.name = "%s" % coord

	var element := get_element_from_id(element_id)
	cell.initialize_with_element(coord, element, separation_offset, _on_clicked_callback)

	return cell
