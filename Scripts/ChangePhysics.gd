extends Node

var p_increment: Dictionary = {"yes":true, "no":false}

export(NodePath) var label_path: NodePath
onready var _label: Label = get_node(label_path)


# Set the physics fps.
var phys_fps_list: Dictionary = {60:" Phy: 60 ", 45:" Phy: 45 ", 30:" Phy: 30 ", 20:" Phy: 20 ", 10:" Phy: 10 ", 5:" Phy: 5 "}
export(int, "60", "45", "30", "20", "10", "5") var phys_tick: int = 0
onready var phys_fps_list_keys: Array = phys_fps_list.keys()


func _ready() -> void:
	# Set starting physics tick.
	next_phys_fps(p_increment.no)


func _physics_process(_delta: float) -> void:
	_label.text =  phys_fps_list[Engine.iterations_per_second] 


func _process(_delta: float) -> void:
	# Input to change physics tick.
	if Input.is_action_just_pressed("ui_page_up"):
		owner.playAudio(owner.mp3Beep1, -6)
		next_phys_fps()


func next_phys_fps(increment: bool = true) -> void:
	if increment: phys_tick += 1
	if phys_tick >= phys_fps_list_keys.size(): phys_tick = 0
	# Set physics speed.
	Engine.iterations_per_second = phys_fps_list_keys[phys_tick]
