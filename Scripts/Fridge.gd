extends Node2D

@export var main_audio: AudioStreamPlayer2D
@export var second_audio: AudioStreamPlayer2D
@export var time: Timer

var beat_length = 0.297  # Length of one beat in seconds
var timer = 0.0
var beat_counter = 0

func _ready():
	main_audio.play()
	#time.wait_time = beat_length * 3
	time.start()
	time.timeout.connect(up_beat)
	second_audio.finished.connect(continue_)


func up_beat():
	main_audio.stop()
	second_audio.play()
	
	
	
func continue_():
	main_audio.play()
