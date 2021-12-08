extends RigidBody


onready var groundSphere: Node = $GroundSphere
onready var parent: Node = get_parent()

var activeContacts: int = 0

func _on_Area_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if  activeContacts == 0:
		parent.was_grounded = parent.is_grounded
		parent.is_grounded = true

	activeContacts += 1


func _on_GroundSphere_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if  activeContacts == 1:
		parent.was_grounded = parent.is_grounded
		parent.is_grounded = false

	activeContacts -= 1
