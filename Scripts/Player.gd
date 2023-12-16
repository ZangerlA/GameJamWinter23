extends CharacterBody2D

const MAX_JUMP_VELOCITY = -1500.0  # Maximum jump velocity
const MIN_JUMP_VELOCITY = -200.0  # Minimum jump velocity for a short press
const MAX_CHARGE_TIME = 1.0       # Maximum time the jump can be charged
const JUMP_HORIZONTAL_SPEED = 1000.0  # Horizontal speed during jump

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_charge = 0.0  # Current charge of the jump
var is_charging_jump = false  # Whether the jump is currently being charged
var jump_direction = 0  # Direction of the jump

func _physics_process(delta):
	# Add gravity when not on the ground.
	if not is_on_floor():
		velocity.y += gravity * delta * 3
	else:
		# Reset horizontal velocity when landing back on the ground.
		velocity.x = 0
	
	
	if Input.is_action_pressed("ui_left"):
		jump_direction = -1
	elif Input.is_action_pressed("ui_right"):
		jump_direction = 1
	
	# Handle jump charging.
	if is_charging_jump:
		# Increment jump charge.
		if is_on_floor():
			jump_charge += delta
			if jump_charge > MAX_CHARGE_TIME:
				jump_charge = MAX_CHARGE_TIME

		# Update jump direction continuously while charging.
	else:
		jump_charge = 0.0

	# Handle jump execution.
	if Input.is_action_just_pressed("ui_accept"):
		is_charging_jump = true
	elif Input.is_action_just_released("ui_accept") and is_on_floor():
		var jump_strength = lerp(MIN_JUMP_VELOCITY, MAX_JUMP_VELOCITY, jump_charge / MAX_CHARGE_TIME)
		velocity.y = jump_strength
		velocity.x = JUMP_HORIZONTAL_SPEED * jump_direction
		is_charging_jump = false

	# Apply movement.
	move_and_slide()
