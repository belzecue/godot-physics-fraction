extends Node

export(Array, NodePath) var ball_np: Array
var balls_rand: Array
var rb_array: Array
var is_impulse_queued: bool


func _init() -> void:
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _ready() -> void:
	# Assign nodepaths to objects.
	for i in ball_np: balls_rand.append(get_node(i))
	
	# Build rigidbody list from ball nodes to randomize impulse.
	for i in balls_rand:
		var rb: RigidBody
		if not i.is_class("RigidBody"):
			var children = i.get_children()
			for j in children:
				if j.is_class("RigidBody"):
					rb = j
					break
			if not rb:
				print("Balls list contains item with no rigidbody!")
				get_tree().quit()
				break
		else:
			rb = i
		
		rb_array.append(rb)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if is_impulse_queued:
		owner.playAudio(owner.mp3Murmur, 0)

		for i in rb_array:
			i.apply_central_impulse(
				Vector3(
					rand_range(-1, 1),
					randf() * 0.5,
					rand_range(-1, 1)
				) * 10
			)
		is_impulse_queued = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_ctrl"): is_impulse_queued = true

