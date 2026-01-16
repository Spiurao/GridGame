class_name Element
extends Node2D

const FALLING_SPEED = 1

var category: String
var new_position := position
var initial_position := position
var is_moving := false
var t: float # for interpolation
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if is_moving:
		# linear interpolation formula A->B : pos(t) = A*(1-t) + B*t
		global_position = initial_position + (new_position - initial_position)\
							* interpolation_bouncing_function(t)
		t += delta * FALLING_SPEED
		if t >= 1: # close enough to the end so setting it to the actual position
			global_position = new_position
			is_moving = false

func interpolation_bouncing_function(x: float) -> float: # making t non linear >:)
	const N = 7.5625
	const D = 2.75

	if (x < 1 / D):
		return N * x * x
	if (x < 2 / D):
		x -= 1.5 / D
		return N * x * x + 0.75
	if (x < 2.5 / D):
		x -= 2.25 / D
		return N * x * x + 0.9375

	x -= 2.625 / D
	return N * x * x + 0.984375

## Starts the movement logic according to the interpolation function
func move_to(pos: Vector2i) -> void:
	initial_position = global_position
	new_position = pos
	is_moving = true
	t = 0
