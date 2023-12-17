extends Node2D

@export var rigidbody: RigidBody2D
var swing_force = 10.0
var swing_direction = 1
var swing_angle = 0.0
var swing_speed = 5.0
var swing_range = 30.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func _physics_process(delta):
	var rotation_threshold = 0.1  # Threshold for rotation in degrees
	var force_strength = 60  # Strength of the force

	# Check if the rotation is within a certain threshold
	if abs(rigidbody.rotation_degrees) < rotation_threshold:
		# Determine the direction of the force based on the y-velocity
		var force_direction = Vector2()
		if rigidbody.linear_velocity.y > 0:
			force_direction = Vector2(-1, 0)
		else:
			force_direction = Vector2(1, 0)

		# Apply force
		rigidbody.apply_impulse(force_direction * force_strength, Vector2.ZERO)

