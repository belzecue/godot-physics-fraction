extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var MIR: Node = get_node("/root/Spatial/Scripts/MakeItRain")
	MIR.cubesHolder = self

