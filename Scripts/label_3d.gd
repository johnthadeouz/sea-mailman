extends Label3D

var state_string = {
	0:"IDLING",
	1:"PATROLLING",
	2:"CHASING",
	3:"PREP_SWARMING",
	4:"SWARMING",
	5:"FLEEING",
}

func update(state:int):
	text = state_string[state]
