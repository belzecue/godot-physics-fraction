extends Node


export(NodePath) var player_np: NodePath
onready var player: PlayerRBPhysTween = get_node(player_np) as PlayerRBPhysTween


func _ready() -> void:
	if not player:
		printerr("No player node assigned.")
		get_tree().quit()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_home"):
		owner.playAudio(owner.mp3Bassgrind if not player.jump_move else owner.mp3Beep3, -6)
		player.jump_move = !player.jump_move
