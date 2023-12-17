extends Node2D

@export var main_audio: AudioStreamPlayer2D
@export var second_audio: AudioStreamPlayer2D
@export var time: Timer

var beat_length = 0.297  # Length of one beat in seconds
var timer = 0.0
var beat_counter = 0

var TimeInSeconds = 15
# Called when the node enters the scene tree for the first time.
func _ready():
	main_audio.play()
	time.start()
	time.timeout.connect(up_beat)
	#time.wait_time = beat_length * 3
	second_audio.finished.connect(continue_)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	TimeInSeconds -= delta
	if TimeInSeconds < 0:
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func up_beat():
	main_audio.stop()
	second_audio.play()
	
	
	
func continue_():
	main_audio.play()
