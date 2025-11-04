extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ACCELERATION = 4
const FRICTION = 2
const ROTATION_SPEED = 2.0

func _physics_process(delta: float) -> void:

	#gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	#Moving boat
	var vy = velocity.y
	velocity.y = 0
	if Input.get_action_strength("move-front"):
		var direction = -transform.basis.z.normalized()
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.z = move_toward(velocity.z, 0, FRICTION * delta)
	velocity.y = vy

	#Turning Boat
	var turn = Input.get_axis("turn-right", "turn-left")
	rotate_y(turn * ROTATION_SPEED * delta)
	
	move_and_slide()
