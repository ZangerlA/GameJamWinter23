extends Node2D

@export var rigidbody: RigidBody2D
var swing_force = 10.0
var swing_direction = 1
var swing_angle = 0.0
var swing_speed = 5.0
var swing_range = 30.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

