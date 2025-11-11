extends CharacterBody3D
class_name Ship
signal package_collected(package: Package)

@export var package: Package
const SPEED:float = 5.0
const JUMP_VELOCITY:float = 4.5
const ACCELERATION:int = 4
const FRICTION:int = 2
const ROTATION_SPEED:float = 2.0
var can_move:bool = true
var is_honking:bool = false
var under_attack:bool = false:
	set(val):
		under_attack = val
		if val:
			can_move = false
			$AnimationPlayer.play("ortogonal_camera_mode")
			show_honk()
		else:
			can_move = true
			$AnimationPlayer.play("normal_camera_mode")
			hide_honk()
			$SirenSlots.clean_slots()


func _ready() -> void:
	if package:
		package.position = $Marker3D.global_position
	$Areas/SirenArea3D.ship = self
	$Areas/HonkArea3D.ship = self


func _physics_process(delta: float) -> void:
	#gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	out_of_bounds_checker()
	#Moving boat
	var vy = velocity.y
	velocity.y = 0
	if can_move and Input.get_action_strength("move-front"):
		var direction = -transform.basis.z.normalized()
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.z = move_toward(velocity.z, 0, FRICTION * delta)
	velocity.y = vy

	var turn = Input.get_axis("turn-right", "turn-left")
	if can_move:#Turning Boat
		rotate_y(turn * ROTATION_SPEED * delta)
	else:#turning horn (combat only)
		$Areas/HonkArea3D.rotate_y(turn * ROTATION_SPEED * delta)
	move_and_slide()


func _input(event: InputEvent) -> void:
	if not under_attack:
		return
	if Input.is_action_just_pressed("siren-counterattack"):
		if not is_honking:
			$HonkParticle/SubViewport/ExpansiveRing.get_node("AnimationPlayer").play("expand")
			is_honking = true
			print("HOOOOONK!")
			$Areas/HonkArea3D.interrupt_siren_song()
			$HonkTimer.start()


func out_of_bounds_checker():
	if position.x > Global.OOW_BOUNDARY:
		position.x -= 50
		print("> OOW_BOUNDARY")
		return
	elif  position.x < -Global.OOW_BOUNDARY:
		position.x += 50
		print("< -OOW_BOUNDARY")
		return
	if  position.z > Global.OOW_BOUNDARY:
		position.z -= 50
		print("> OOW_BOUNDARY")
		return
	elif  position.z < -Global.OOW_BOUNDARY:
		position.z += 50
		print("< -OOW_BOUNDARY")


func append_slave_and_get_position():
	return $SirenSlots.append_slave_and_get_position()


func show_honk():
	$Areas/HonkArea3D.visible = true
	$Areas/HonkArea3D.rotation_degrees.y = 0


func hide_honk():
	$Areas/HonkArea3D.visible = false


func deliver_package():
	if package:
		print("Package delivered")
		package.queue_free()


func face_compass_to_next_island(next_island_pos:Vector3):
	var next_island_dir = global_position.direction_to(next_island_pos).normalized()
	$Compass.look_at(next_island_pos, Vector3.UP)


func _on_hitbox_body_entered(body) -> void:
	if body.get_collision_layer_value(1) and package and !body.name == "Sea":
		package.take_damage(10)


func _on_honk_timer_timeout() -> void:
	is_honking = false


func _on_collect_area_body_entered(body) -> void:
	if body.is_in_group("Package") and !package:
		var package_root = body.get_parent()
		package = package_root
		package_collected.emit(package_root)
