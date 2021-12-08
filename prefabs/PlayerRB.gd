extends RigidBody


onready var groundSphere: Node = $GroundSphere
onready var parent: Node = get_parent()

var activeContacts: int = -1 # Ignore nitial contact with self

func _on_Area_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if  activeContacts == 0:
		parent.was_grounded = parent.is_grounded
		parent.is_grounded = true
		#print("... entered: ", activeContacts)

	activeContacts += 1


func _on_GroundSphere_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if  activeContacts == 1:
		parent.was_grounded = parent.is_grounded
		parent.is_grounded = false
		#print("... exited: ", activeContacts)

	activeContacts -= 1
