extends CharacterBody3D
class_name Siren

var original_position
const MAX_DISTANCE = 10
const SPEED = 4.0
const JUMP_VELOCITY = 4.5
enum state{
	IDLING,
	PATROLLING,
	ATTACKING,
	FLEEING,
}
var state_wait_time = {
	state.IDLING:8,
	state.PATROLLING:4,
}
var current_state:state = state.IDLING:
	set(val):
		current_state = val
		$Label3D.update(val)
		
var direction = Vector3.ZERO


func _ready() -> void:
	original_position = global_position
	$StateTimer.start()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func set_new_direction():
	if global_position.distance_to(original_position) > MAX_DISTANCE:
		return global_position.direction_to(original_position).normalized()
	else:
		var dir_x = randf_range(-1,1)
		var dir_y = randf_range(-1,1)
		return (transform.basis * Vector3(dir_x, 0, dir_y)).normalized()


func start_attacking(boat:CharacterBody3D):
	direction = Vector3.ZERO
	current_state = state.ATTACKING
	$StateTimer.stop()


func _on_state_change_timeout() -> void:
	match current_state:
		state.IDLING:
			direction = set_new_direction()
			current_state = state.PATROLLING
		state.PATROLLING:
			direction = Vector3.ZERO
			current_state = state.IDLING
	$StateTimer.start(state_wait_time[current_state])
