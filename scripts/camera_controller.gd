extends Node3D

@onready var yaw_node = $CamYaw
@onready var pitch_node = $CamYaw/CamPitch
@onready var camera_node = $CamYaw/CamPitch/Camera3D

var yaw : float = 0
var pitch : float = 0

var yaw_sensitivity : float = 0.7
var pitch_sensitivity : float = 0.7

var yaw_accelleration : float = 15
var pitch_accelleration : float = 15

func _input(event):
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sensitivity
		pitch += event.relative.y * pitch_sensitivity

func _physics_process(delta: float) -> void:
	yaw_node.rotation_degrees.y = lerp(yaw_node.rotation_degrees.y, yaw, yaw_accelleration * delta)
	pitch_node.rotation_degrees.x = lerp(pitch_node.rotation_degrees.x, pitch, pitch_accelleration * delta)
