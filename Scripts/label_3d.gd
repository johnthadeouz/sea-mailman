extends Label3D

var state_string = {
	0:"IDLING",
	1:"PATROLLING",
	2:"PREP_SWARMING",
	3:"SWARMING",
	4:"FLEEING",
}

func update(state:int):
	text = state_string[state]
