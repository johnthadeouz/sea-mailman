extends CharacterBody3D
class_name Siren

var original_position
const MAX_PATROLLING_DISTANCE = 10
const MAX_CHASING_DISTANCE = 20
const SPEED = 4.0
const JUMP_VELOCITY = 4.5
enum state{
	IDLING,
	PATROLLING,
	PREP_SWARMING,
	SWARMING,
	FLEEING,
}
var state_wait_time = {
	state.IDLING:8,
	state.PATROLLING:4,
	state.PREP_SWARMING:0.5,
	state.SWARMING:2,
}
var current_state:state = state.IDLING:
	set(val):
		current_state = val
		$Label3D.update(val)
		
var direction = Vector3.ZERO
var ship_last_seen_pos = Vector3.ZERO
var is_singing = false


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


func get_new_direction():
	if global_position.distance_to(original_position) > MAX_PATROLLING_DISTANCE:
		return global_position.direction_to(original_position).normalized()
	else:
		var dir_x = randf_range(-1,1)
		var dir_y = randf_range(-1,1)
		return (transform.basis * Vector3(dir_x, 0, dir_y)).normalized()


func start_attacking(boat:CharacterBody3D):
	direction = Vector3.ZERO
	current_state = state.PREP_SWARMING
	ship_last_seen_pos = boat.global_position
	$StateTimer.stop()
	$StateTimer.start(state_wait_time[current_state])
	


func chase_ship(boat:CharacterBody3D):
	current_state = state.PATROLLING
	await get_tree().create_timer(1.0).timeout
	if global_position.distance_to(original_position) > MAX_CHASING_DISTANCE:
		direction = global_position.direction_to(original_position).normalized()
	else:
		direction = global_position.direction_to(boat.position).normalized()
	$StateTimer.start(state_wait_time[current_state])



func sing():
	if not is_singing:
		is_singing = true
		print("IS SINGING")
		$Node3D/SubViewport/ExpansiveRing.get_node("AnimationPlayer").play("prepare_siren_song")
		await $Node3D/SubViewport/ExpansiveRing.ANIM_FINISHED
		$Node3D/SubViewport/ExpansiveRing.get_node("AnimationPlayer").play("expand_siren")
		await $Node3D/SubViewport/ExpansiveRing.ANIM_FINISHED
		print("STOPED SINGING")
		is_singing = false


func break_song_and_die():
	shake()
	var song = $Node3D/SubViewport/ExpansiveRing
	var tween:Tween = create_tween()
	tween.tween_property(song.material, "shader_parameter/ring_radius", 0.1, 2.0)
	tween.parallel().tween_property(song.material,"shader_parameter/thickness_scalar",0.0,2.0)
	await tween.finished
	queue_free()
	return true

func shake():
	var tween:Tween = create_tween()
	tween.tween_property($CSGBox3D,"position:x",0.4,0.3)
	tween.tween_property($CSGBox3D,"position:x",-0.8,0.3)
	tween.tween_property($CSGBox3D,"position:x",0.4,0.3)

	


func _on_state_change_timeout() -> void:
	match current_state:
		state.IDLING:
			direction = get_new_direction()
			current_state = state.PATROLLING
			
		state.PATROLLING:
			direction = Vector3.ZERO
			current_state = state.IDLING
			
		state.PREP_SWARMING:
			current_state = state.SWARMING

		state.SWARMING:
			sing()
			
	$StateTimer.start(state_wait_time[current_state])
