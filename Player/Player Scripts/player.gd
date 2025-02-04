extends RigidBody3D


@onready var twistpivot = $Twistpivot
@onready var pitchpivot = $Twistpivot/Pitchpivot


# Basic variables
const SPEED: float = 2200.0

var mouse_sensitivity: float = 0.003
var twist_input: float = 0.0
var pitch_input: float = 0.0

var esc_pressed_once: bool = false
var esc_pressed_twice: bool = false
var esc_pressed_third: bool = false
var esc_pressed_fourth: bool = false
var esc_pressed_fifth: bool = false


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if Input.is_action_just_pressed("esc"):
		if not esc_pressed_once:
			esc_pressed_once = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif not esc_pressed_twice:
			esc_pressed_twice = true
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif not esc_pressed_third:
			esc_pressed_third = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif not esc_pressed_fourth:
			esc_pressed_fourth = true
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif not esc_pressed_fifth:
			esc_pressed_fifth = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _process(delta: float) -> void: # Update the game in real-time
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")

	apply_central_force(input * SPEED * delta)
	
	twistpivot.rotate_y(twist_input)
	pitchpivot.rotate_x(pitch_input)
	pitchpivot.rotation.x = clamp(
		pitchpivot.rotation.x,
		-0.5,
		0.5
	)
	twist_input = 0.0
	pitch_input = 0.0


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
