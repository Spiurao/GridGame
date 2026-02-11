extends StateMachine

func _ready():
	add_state("idle")
	add_state("changing")
	state = states.idle

func _state_logic(_delta):
	#if state == somestate then do logic etc...
	pass

func _get_transition(_delta):
	match state:
		states.idle:
			if parent.is_changing():
				state = states.changing
		states.changing:
			if not parent.is_changing():
				state = states.idle

func _enter_state(new_state, _old_state):
	match new_state:
		states.idle:
			parent.emit_signal("grid_is_changing", false)
		states.changing:
			parent.emit_signal("grid_is_changing", true)

func _exit_state(_old_state, _new_state):
	pass
