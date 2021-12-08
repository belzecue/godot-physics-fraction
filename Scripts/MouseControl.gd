extends Node


const deg2rad_mult : float = 0.0174533
const sixty_delta: float = 0.016666667

export(NodePath) var pivot_xaxis_np : NodePath  # Node for x-axis mouse rotation.
export(NodePath) var pivot_yaxis_np : NodePath # Node for y-axis mouse rotation.
onready var pivot_xaxis: Spatial = get_node(pivot_xaxis_np)
onready var pivot_yaxis: Spatial = get_node(pivot_yaxis_np)

export(bool) var mouse_x_invert : bool = false # Invert mouse x-axis input.
export(bool) var mouse_y_invert : bool = false # Invert mouse y-axis input.
export(float, 0, 12, 0.5) var mouse_rotate_speed : float = 8 # Mouse rotation strength/speed.
export(int, 0, 90) var clamp_xaxis_deg : int = 80
export(float, 0, 1, 0.05) var mouse_smoothing : float = 1 # Mouse smoothing strength.
export(float, 0, 500, 10) var x_axis_adjust = 200

onready var bool_mouse_x_invert : int = mouse_x_invert as int * 2 - 1
onready var bool_mouse_y_invert : int = mouse_y_invert as int * 2 - 1
onready var mouse_smoothing_range : float = 1.0 - mouse_smoothing * 0.5

var event_relative : Vector2
var mouse_scaling_mult : Vector2
var do_clamp_xaxis_deg : bool
var clamp_xaxis_rad : float


func _input(event) -> void:

	# Handle mouse.
	if event is InputEventMouseMotion:
		# Apply mouse values, inversion and scaling.
		event_relative += Vector2(
			event.relative.x * -bool_mouse_y_invert,
			event.relative.y * -bool_mouse_x_invert
		) * mouse_scaling_mult * mouse_rotate_speed * deg2rad_mult * get_process_delta_time()


func _ready() -> void:
	# Hide mouse.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var screen : Vector2 = get_viewport().size
	mouse_scaling_mult = Vector2(1920.0 / screen.y, 1920.0 / screen.x)
	
	do_clamp_xaxis_deg = false if clamp_xaxis_deg == 0 else true
	if do_clamp_xaxis_deg:
		clamp_xaxis_rad = abs(clamp_xaxis_deg) * deg2rad_mult


func _process(delta: float) -> void:
	# Calculate new node_subject_yaxis rotation.
	if pivot_yaxis:
		pivot_yaxis.rotate(-pivot_yaxis.transform.basis.y, (sixty_delta / delta) * event_relative.x)
	if pivot_xaxis:
		pivot_xaxis.rotate(-pivot_xaxis.transform.basis.x, (sixty_delta / delta) * event_relative.y)
		if do_clamp_xaxis_deg:
			pivot_xaxis.rotation.x = clamp(pivot_xaxis.rotation.x, -clamp_xaxis_rad, clamp_xaxis_rad)
	
	event_relative = Vector2.ZERO



