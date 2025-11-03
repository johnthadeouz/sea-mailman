extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const acceleration = 4
const friction = 2
var rotation_speed = 2.0

func _physics_process(delta: float) -> void:


	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var vy = velocity.y
	velocity.y = 0
	if Input.get_action_strength("move-front"):
		var direction = -transform.basis.z.normalized()
		velocity.x = move_toward(velocity.x, direction.x * SPEED, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)
	velocity.y = vy
	#print(velocity)

	#_rotate(delta)
	#Turning Boat
	var turn = Input.get_axis("turn-right", "turn-left")
	rotate_y(turn * rotation_speed * delta)

	move_and_slide()



func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
	
	
	
func get_input(delta):
	var vy = velocity.y
	velocity = Vector3.ZERO
	var move = Input.get_axis("back", "forward")
	var turn = Input.get_axis("right", "left")
	velocity += -transform.basis.z * move * SPEED
	rotate_y(rotation_speed * turn * delta)
	velocity.y = vy



func _rotate(delta):
	var input_dir = Input.get_vector("turn-left", "turn-right", "move-front", "move-back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction: # Only rotate if there's a movement input
		# Calculate the target rotation based on the direction
		var target_rotation_y = atan2(-direction.x, -direction.z) 

		# Smoothly interpolate the character's Y rotation
		rotation.y = lerp_angle(rotation.y, target_rotation_y, delta * rotation_speed)
