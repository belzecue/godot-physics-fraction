extends Node


export(Array, NodePath) var hide_list: Array


func _ready() -> void:
	for i in hide_list:
		get_node(i).queue_free()
