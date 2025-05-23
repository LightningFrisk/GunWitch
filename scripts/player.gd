extends CharacterBody3D

signal pressed_jump(jump_state:JumpState)
signal set_movement_state (_movement_state : MovementState)
signal set_movement_direction(_movement_direction : Vector3)

@export var movement_states: Dictionary
@export var jump_states : Dictionary

var movement_direction : Vector3
var air_jump_counter : int = 0
var max_air_jump: int = 1


func _input(event):
	if event.is_action("movement") or event.is_action_released("movement"): #this function determines movement direction, functions as left + right pressed as neutral
		movement_direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
		movement_direction.z = Input.get_action_strength("forward") - Input.get_action_strength("back")
		
		if is_movement_ongoing(): #calls the properties of the type of movement player is doing
			if Input.is_action_pressed("sprint"):
				set_movement_state.emit(movement_states["sprint"])
			else:
				if Input.is_action_pressed("walk"):
					set_movement_state.emit(movement_states["walk"])
				else:
					set_movement_state.emit(movement_states["run"])
		else:
			set_movement_state.emit(movement_states["stand"])

func _ready(): #by default sets to standing
	set_movement_state.emit(movement_states["stand"])

func _physics_process(_delta: float) -> void: #emits movement direction
	if is_movement_ongoing():
		set_movement_direction.emit(movement_direction)
		
	if is_on_floor():
		air_jump_counter = 0
	elif air_jump_counter == 0:
		air_jump_counter = 1
	
	if air_jump_counter <= max_air_jump:
		if Input.is_action_just_pressed("jump"):
			var jump_name : String = "ground_jump"
			
			if air_jump_counter > 0:
				jump_name = "air_jump"
				
			pressed_jump.emit(jump_states[jump_name])
			air_jump_counter += 1

func is_movement_ongoing() -> bool: #verifies that movement is greater than 0, positive, so no moon walking
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0
