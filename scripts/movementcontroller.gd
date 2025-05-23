extends Node

@export var player : CharacterBody3D
@export var mesh_root : Node3D
@export var rotation_speed : float = 8
@export var fall_gravity = 45
var jump_gravity : float = fall_gravity
var direction : Vector3
var velocity : Vector3
var acceleration : float
var speed : float 
var cam_rotation : float

func _physics_process(delta: float) -> void:
#	takes speed + direction to make this a vector 3 and determine overall movements
	velocity.x = speed * direction.normalized().x
	velocity.z = speed * direction.normalized().z
	
	if not player.is_on_floor(): #makes the player fall, also allows fall rate to be slower when falling than with jumping
		if velocity.y >= 0: 
			velocity.y -= jump_gravity * delta
		else:
			velocity.y -= fall_gravity * delta
	
	#I'm pretty sure this is going to give the 'weight', linear interpolating speed with the desired speed and acceleration, normalized by delta
	player.velocity = player.velocity.lerp(velocity, acceleration * delta)
	player.move_and_slide()
	#does the same thing except for rotation of the character. This should prevent the snappy movement I had on the previous controller
	var target_rotation = atan2(direction.x, direction.z) - player.rotation.y
	mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, rotation_speed * delta)

func _jump(jump_state: JumpState):
	velocity.y = 2 * jump_state.jump_height / jump_state.apex_duration
	jump_gravity = velocity.y /jump_state.apex_duration

#recieve function state and direction from Player
func _on_set_movement_state(_movement_state : MovementState):
	speed = _movement_state.movement_speed
	acceleration = _movement_state.acceleration

func _on_set_movement_direction(_movement_direction : Vector3):
	direction = _movement_direction.rotated(Vector3.UP, cam_rotation) #sets the direction on the cardinal directions via WSAD, then modifies it by the camera rotation

func _on_set_cam_rotation(_cam_rotation: float):
	cam_rotation = _cam_rotation
