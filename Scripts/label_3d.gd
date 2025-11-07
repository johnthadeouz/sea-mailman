extends Label3D

var state_string: Dictionary = {
	0:"IDLING",
	1:"PATROLLING",
	2:"PREP_COMBATING",
	3:"COMBATING",
	4:"FLEEING",
}

func update(state:int):
	text = state_string[state]
