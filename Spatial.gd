extends Spatial


onready var audioPlayer1: AudioStreamPlayer = get_node("Audio/AudioStreamPlayer1") as AudioStreamPlayer
onready var audioPlayer2: AudioStreamPlayer = get_node("Audio/AudioStreamPlayer2") as AudioStreamPlayer
onready var audioPlayer3: AudioStreamPlayer = get_node("Audio/AudioStreamPlayer3") as AudioStreamPlayer
onready var mp3Whoosh: AudioStreamMP3 = preload("res://Audio/whoosh.mp3") as AudioStreamMP3
onready var mp3Murmur: AudioStreamMP3 = preload("res://Audio/murmur.mp3") as AudioStreamMP3
onready var mp3Whah: AudioStreamMP3 = preload("res://Audio/whah.mp3") as AudioStreamMP3
onready var mp3Beep1: AudioStreamMP3 = preload("res://Audio/beep_1.mp3") as AudioStreamMP3
onready var mp3Beep2: AudioStreamMP3 = preload("res://Audio/beep_2.mp3") as AudioStreamMP3
onready var mp3Beep3: AudioStreamMP3 = preload("res://Audio/beep_3.mp3") as AudioStreamMP3
onready var mp3Bassgrind: AudioStreamMP3 = preload("res://Audio/bassgrind.mp3") as AudioStreamMP3


var playingSound: Dictionary = {}

func _ready() -> void:
	pass

func playAudio(stream: AudioStreamMP3, db: int):
	if not playingSound.has(stream) or playingSound[stream] == false:
		var player: AudioStreamPlayer = audioPlayer1 if not audioPlayer1.playing else audioPlayer2 if not audioPlayer2.playing else audioPlayer3
		playingSound[stream] = true
		player.volume_db = db
		player.stream = stream
		player.play()


func _on_AudioStreamPlayer1_finished():
	playingSound[audioPlayer1.stream] = false


func _on_AudioStreamPlayer2_finished():
	playingSound[audioPlayer2.stream] = false


func _on_AudioStreamPlayer3_finished():
	playingSound[audioPlayer3.stream] = false
