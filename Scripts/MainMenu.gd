extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			get_tree().change_scene_to_file("res://Scenes/TestLevel.tscn")
