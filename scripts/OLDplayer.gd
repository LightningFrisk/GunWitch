extends CharacterBody3D

@onready var camera_mount = $cameraMount
@onready var animation_player = $visuals/mixamo_base/AnimationPlayer
@onready var visuals = $visuals

var SPEED = 2.8
const JUMP_VELOCITY = 4.5

var walking_speed = 3.0
var running_speed = 5.0

var running = false
var is_locked = false

@export var sens_horizontal = .35
@export var sens_vertical = .2

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal)) #converts mousemovement to camera movement
		visuals.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta: float) -> void:
	
	if !animation_player.is_playing():
		is_locked = false
	
	if Input.is_action_just_pressed("kick"):
		if animation_player.current_animation != "kick" and is_on_floor():
			animation_player.play("kick")
			is_locked = true
	
	if Input.is_action_pressed("run"):
		SPEED = running_speed
		running = true
	else:
		SPEED = walking_speed
		running = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		#if !is_locked: #realized there's no jump animation
			#if animation_player.current_animation != "jump":
				#animation_player.play()
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !is_locked:
			if animation_player.current_animation != "walking" and !running:
				animation_player.play("walking")
				
			if animation_player.current_animation != "running" and running:
				animation_player.play("running")
			
			visuals.look_at(position + direction)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if !is_locked:
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
		
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if !is_locked:
		move_and_slide()
