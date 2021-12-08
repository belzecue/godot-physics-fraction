"""

Type: RidigBodyPhysicsTween

Interpolates a visualbody paired with a rigidbody so that movement is smooth
at all physics ticks.  If no fast moving objects in game then can turn down
physics to e.g. 30 to save on compute.

To set up:
	- create a scene-root spatial node, add this script
	- Add a rigidbody and a mesh (VisualBody) as sibling children
	- If needing a different origin to rigidbody's origin, add a spatial
	  as child of the rigidbody (VisualBodyTarget)

	Assign these to the script's nodepaths.
	
"""

extends Spatial

class_name RigidBodyPhysicsTween, "icons/basketball_red.svg"

# Exported nodepaths.
export(NodePath) var rigid_body_path: NodePath
export(NodePath) var visual_body_target_path: NodePath
export(NodePath) var visual_body_path: NodePath


# Assigned nodes.
onready var rigid_body: RigidBody = get_node(rigid_body_path)
onready var visual_body: Spatial = get_node(visual_body_path)
onready var visual_body_target: Spatial = get_node(visual_body_target_path)

# Variables.
var visual_body_transform_old: Transform
var visual_body_velocity: float
var visual_body_velocity_previous: float


func _init() -> void:
	# Switch off physics jitter fix because we are using manual interpolation.
	# -> Move to game manager startup if many instances.
	if Engine.physics_jitter_fix != 0: Engine.physics_jitter_fix = 0


func _ready() -> void:
	# Sanity checks.
	if not rigid_body or not visual_body or not visual_body_target:
		printerr("RidigBodyPhysicsTween Error: Missing assigned body for " + self.name)
		get_tree().quit()


func _physics_process(_delta: float) -> void:
	# Store current transform for physics body.
	visual_body_transform_old = visual_body_target.global_transform
	

func _process(delta: float) -> void:
	var visual_body_last_pos: Vector3 = visual_body.global_transform.origin
	
	# Interpolate movement for visual body.
	visual_body.global_transform = visual_body_transform_old.interpolate_with(
		visual_body_target.global_transform,
		Engine.get_physics_interpolation_fraction()
	)
	
	# Calculate visual body's velocity.
	# REMOVE THIS if tracking velocity is not needed.
	visual_body_velocity_previous = visual_body_velocity
	visual_body_velocity = visual_body_last_pos.distance_to(visual_body.global_transform.origin) / delta

