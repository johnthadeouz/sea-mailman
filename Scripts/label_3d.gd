extends Label3D

var state_string = {
	0:"IDLING",
	1:"PATROLLING",
	2:"ATTACKING",
	3:"FLEEING",
}

func update(state:int):
	text = state_string[state]
