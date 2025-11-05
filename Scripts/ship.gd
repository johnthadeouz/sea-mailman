extends CharacterBody3D
class_name Ship

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ACCELERATION = 4
const FRICTION = 2
const ROTATION_SPEED = 2.0
var can_move = true
var is_honking = false
var under_attack = false:
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

@export var package: Package

signal package_collected(package: Package)

func show_honk():
	$HonkArea3D.visible = true
	$HonkArea3D.rotation_degrees.y = 0
	
func hide_honk():
	$HonkArea3D.visible = false

func _ready() -> void:
	if package:
		package.position = $Marker3D.global_position

func _physics_process(delta: float) -> void:

	#gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		
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
		$HonkArea3D.rotate_y(turn * ROTATION_SPEED * delta)
	move_and_slide()
	
func deliver_package():
	if package:
		print("Package delivered")
		package.queue_free()


func _on_hitbox_body_entered(body) -> void:
	if body.get_collision_layer_value(1) and package and !body.name == "Sea":
		package.take_damage(10)
	
	
func _input(event: InputEvent) -> void:
	if not under_attack:
		return
	if Input.is_action_just_pressed("siren-counterattack"):
		if not is_honking:
			$Node3D/SubViewport/ExpansiveRing.get_node("AnimationPlayer").play("expand")
			is_honking = true
			print("HOOOOONK!")
			$HonkArea3D.interrupt_siren_song()
			$HonkTimer.start()


func _on_honk_timer_timeout() -> void:
	is_honking = false


func _on_collect_area_body_entered(body) -> void:
	if body.is_in_group("Package") and !package:
		var package_root = body.get_parent()
		package = package_root
		package_collected.emit(package_root)
