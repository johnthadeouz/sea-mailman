extends CharacterBody3D
class_name Siren
signal COMBAT_STARTED

static var slave_sirens = load("res://Scenes/Characters/slavesiren.tscn")
var original_position:Vector3
const MAX_SLAVES:int = 4
const MAX_PATROLLING_DISTANCE:int = 10
const MAX_CHASING_DISTANCE:int = 20
var speed:float = 4.0
enum state{
	IDLING,
	PATROLLING,
	PREP_COMBATING,
	COMBATING,
	FLEEING,
}
var state_wait_time:Dictionary = {
	state.IDLING:8,
	state.PATROLLING:4,
	state.PREP_COMBATING:1.0,
	state.COMBATING:2,
	state.FLEEING:4,
}
var current_state:state = state.IDLING:
	set(val):
		current_state = val
		$Label3D.update(val)
		
var direction:Vector3 = Vector3.ZERO
var ship_last_seen_pos:Vector3 = Vector3.ZERO
var target_ship:Ship = null
var is_singing:bool = false
var is_slave:bool = false
var master:Siren = null
var slaves:Array[Siren] = []
var is_coward:bool = false


func _ready() -> void:
	if not is_slave:
		if randi_range(1,3) == 3:
			is_coward = true
		original_position = global_position
		$StateTimer.start()



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Get the input direction and handle the movement/deceleration.
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()



func get_new_direction():
	if global_position.distance_to(original_position) > MAX_PATROLLING_DISTANCE:
		return global_position.direction_to(original_position).normalized()
	else:
		var dir_x = randf_range(-1,1)
		var dir_y = randf_range(-1,1)
		return (transform.basis * Vector3(dir_x, 0, dir_y)).normalized()



func start_attacking(ship:CharacterBody3D):
	direction = Vector3.ZERO
	current_state = state.PREP_COMBATING
	ship_last_seen_pos = ship.global_position
	target_ship = ship
	$StateTimer.stop()
	$StateTimer.start(state_wait_time[current_state])
	


func chase_ship(boat:CharacterBody3D):
	$StateTimer.stop()
	emit_signal("COMBAT_STARTED", false)
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



func create_slave():
	if slaves.size() >= MAX_SLAVES:
		return false
	var available_pos = target_ship.append_slave_and_get_position()
	if not available_pos:
		return false
	var new_slave:Siren = slave_sirens.instantiate()
	new_slave.is_slave = true
	get_parent().add_child(new_slave)
	slaves.append(new_slave)
	new_slave.master = self
	new_slave.global_position = available_pos
	return true



func break_song_and_die():
	shake()
	var song = $Node3D/SubViewport/ExpansiveRing
	var tween:Tween = create_tween()
	tween.tween_property(song.material, "shader_parameter/ring_radius", 0.1, 2.0)
	tween.parallel().tween_property(song.material,"shader_parameter/thickness_scalar",0.0,2.0)
	await tween.finished
	if is_slave:
		var my_index = master.slaves.find(self)
		master.slaves.remove_at(my_index)
	queue_free()
	return true



func flee(dir):
	current_state = state.FLEEING
	direction = dir
	speed = speed*2
	if not is_slave:
		$StateTimer.stop()
		$StateTimer.start(state_wait_time[current_state])



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
			
		state.PREP_COMBATING:
			current_state = state.COMBATING
			emit_signal("COMBAT_STARTED", true)

		state.COMBATING:
			var rand = randi_range(1,10)
			if not create_slave():
				slaves.shuffle()
				slaves[0].sing()
				
		state.FLEEING:
			for slave in slaves:
				slave.queue_free()
			queue_free()
			
	$StateTimer.start(state_wait_time[current_state])
