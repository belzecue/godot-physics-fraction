extends Node


export(NodePath) var fps_label_np: NodePath
onready var fps_label: Label = get_node(fps_label_np)

# Set the fps.
export(int, "60", "45", "30", "20", "10", "5") var fps: int = 0
onready var fps_list_keys: Array = [60, 45, 30, 20, 10, 5]

var p_increment: Dictionary = {"yes":true, "no":false}


func _ready() -> void:
	# Set starting fps.
	next_fps(p_increment.no)


func _process(_delta: float) -> void:
	# Input to change fps.
	if Input.is_action_just_pressed("ui_page_down"):
		owner.playAudio(owner.mp3Beep2, -6)
		next_fps()
	fps_label.text = " FPS: " + Engine.get_frames_per_second() as String + " "


func next_fps(increment: bool = true) -> void:
	if increment: fps += 1
	if fps >= fps_list_keys.size(): fps = 0
	# Set physics speed.
	Engine.set_target_fps(fps_list_keys[fps])
