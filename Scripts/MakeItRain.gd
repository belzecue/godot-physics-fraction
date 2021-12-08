extends Node


export (PackedScene) var cube: PackedScene
export (NodePath) var ceilingNode_np: NodePath
export (NodePath) var cubeHolder_np: NodePath
export(NodePath) var cubes_label_np: NodePath

# Assign Nodes from paths
onready var ceiling: MeshInstance = get_node(ceilingNode_np) as MeshInstance
onready var cubeHolder: Node = get_node(cubeHolder_np) as Node
onready var cubes_label: Label = get_node(cubes_label_np)


var ceilingBounds: AABB
var cubes_count: int = 0


func _ready():
	randomize()
	ceilingBounds = ceiling.get_transformed_aabb()


func _process(_delta: float) -> void:
	# Input to make it rain cubes.
	if Input.is_action_just_pressed("ui_insert"):
		owner.playAudio(owner.mp3Whah, 0)
		MakeItRain()


func MakeItRain() -> void:
	for i in randi() % 20:
		var inst: Spatial = cube.instance()
		var newPos = ceilingBounds.position + Vector3(
			ceilingBounds.size.x * randf(),
			-1,
			ceilingBounds.size.z * randf()
		)
		var newRot = Quat(
			Vector3(randf(), randf(), randf()).normalized(),
			randf() * 10 * -1.0 if randf() < 0.5 else 1.0
		)
		inst.transform.origin = newPos
		inst.transform.basis = Basis(newRot)
		cubeHolder.add_child(inst)
		cubes_count += 1
	
	cubes_label.text = " Cubes: " + cubes_count as String + " "
