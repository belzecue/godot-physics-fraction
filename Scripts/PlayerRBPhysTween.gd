extends RigidBodyPhysicsTween

class_name PlayerRBPhysTween

const sixty_delta: float = 0.016666667

export var acceleration: float = 2000
export var max_velocity: float = 6
export var run_multiplier: float = 2
export var jump_strength: float = 12
export var jump_move: bool

export(NodePath) var dir_source_np: NodePath

onready var dir_source: Camera = get_node(dir_source_np) as Camera
onready var acceleration_orig: float = acceleration
onready var max_velocity_orig: float = max_velocity
onready var max_velocity_squared: float = max_velocity * max_velocity
onready var max_velocity_squared_orig: float = max_velocity_squared
onready var linear_damp_orig: float = rigid_body.linear_damp

var input_velocity: Vector3
var is_grounded: bool = false # We start in air, falling.
var was_grounded: bool = not is_grounded
var ground_normal: Vector3 = Vector3.UP
var is_running: bool
var want_jump: bool
var moving_threshold: float = 0.4


func _physics_process(delta: float) -> void:
	# Handle linear damping for air versus ground.
	if not was_grounded and is_grounded:
		# Air to Ground.
		rigid_body.linear_damp = linear_damp_orig
	elif was_grounded and not is_grounded:
		# Ground to Air.
		rigid_body.linear_damp = -1

	# Apply physics forces from input.
	if input_velocity != Vector3.ZERO:
		var adjusted_velocity: Vector3 = input_velocity * acceleration * (sixty_delta / delta)
		if is_grounded:
			# Grounded.
			rigid_body.add_central_force(
				adjusted_velocity
			)
		elif jump_move:
			# Not grounded and jump moving allowed.
			var rbvsq: float = rigid_body.linear_velocity.length_squared()
			if rbvsq < max_velocity_squared:
				rigid_body.add_central_force(
					adjusted_velocity * lerp(1, 0, rbvsq / max_velocity_squared) # Throttle to max speed.
				)
		
		input_velocity = Vector3.ZERO
	
	# Handle jumping.
	if want_jump:
		if is_grounded:
			owner.playAudio(owner.mp3Whoosh, -24)
		
		rigid_body.apply_central_impulse(
			ground_normal * jump_strength * lerp(1, 3, (delta - sixty_delta) / 0.18333) # Fix for jump falloff as phys tick decreases.
		)
		want_jump = false


func _process(delta: float) -> void:
	
	# Input for speed multiplier.
	if Input.is_action_just_pressed("ui_run"):
		is_running = true
		acceleration *= run_multiplier
		max_velocity *= run_multiplier
		max_velocity_squared *= run_multiplier
	if Input.is_action_just_released("ui_run"):
		is_running = false
		acceleration = acceleration_orig
		max_velocity = max_velocity_orig
		max_velocity_squared = max_velocity_squared_orig

	# Input for direction keys.
	var input_vector: Vector3 = Vector3.ZERO
	var basis: Basis = dir_source.global_transform.basis

	if is_grounded:
		# When grounded, lock movement to X-Z plane.
		if Input.is_action_pressed("ui_left"):
			input_vector += basis.z.cross(ground_normal)
		if Input.is_action_pressed("ui_right"):
			input_vector += -basis.z.cross(ground_normal)
		if Input.is_action_pressed("ui_up"):
			input_vector += -basis.x.cross(ground_normal)
		if Input.is_action_pressed("ui_down"):
			input_vector += basis.x.cross(ground_normal)
		
		# Jumping allowed only when grounded.
		if Input.is_action_just_pressed("ui_accept"):
			want_jump = true
			
	elif jump_move:
		# In air, allow movement in all directions, if in-air movement allowed.
		if Input.is_action_pressed("ui_left"):
			input_vector += -basis.x
		if Input.is_action_pressed("ui_right"):
			input_vector += basis.x
		if Input.is_action_pressed("ui_up"):
			input_vector += -basis.z
		if Input.is_action_pressed("ui_down"):
			input_vector += basis.z
		
		# Also allow jumping anytime when jump_move active.
		if Input.is_action_just_pressed("ui_accept"):
			want_jump = true


	# Normalize directional input and scale to fps.
	if input_vector != Vector3.ZERO:
		input_velocity += input_vector.normalized() * delta
	

