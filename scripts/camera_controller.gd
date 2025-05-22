extends Node3D

signal set_cam_rotation(_cam_rotation:float)

@onready var yaw_node = $CamYaw
@onready var pitch_node = $CamYaw/CamPitch
@onready var camera_node = $CamYaw/CamPitch/SpringArm3D/Camera3D

var tween : Tween

var yaw : float = 0
var pitch : float = 0

var yaw_sensitivity : float = 0.7
var pitch_sensitivity : float = 0.7

var yaw_accelleration : float = 15
var pitch_accelleration : float = 15

var pitch_max = 60
var pitch_min = -75

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sensitivity
		pitch += event.relative.y * pitch_sensitivity

func _physics_process(delta: float) -> void:
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	yaw_node.rotation_degrees.y = lerp(yaw_node.rotation_degrees.y, yaw, yaw_accelleration * delta)
	pitch_node.rotation_degrees.x = lerp(pitch_node.rotation_degrees.x, pitch, pitch_accelleration * delta)
	
	set_cam_rotation.emit(yaw_node.rotation.y)

func _on_set_movement_state(_movement_state : MovementState):
	if tween: #prevents function from running multiple times if called repeatedly
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(camera_node, "fov", _movement_state.camera_fov, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
