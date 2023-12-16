extends CharacterBody2D

const MAX_JUMP_VELOCITY = -1500.0  # Maximum jump velocity
const MIN_JUMP_VELOCITY = -200.0  # Minimum jump velocity for a short press
const MAX_CHARGE_TIME = 1.0       # Maximum time the jump can be charged
const JUMP_HORIZONTAL_SPEED = 1000.0  # Horizontal speed during jump

@export var trajectory_line: Line2D
@export var sprite: Sprite2D
@export var label: Label

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# damage
var peak_height = 0
var fall_damage_threshold = 50
var damage_taken_counter = 0

# jump parameter
var jump_charge = 0.0  # Current charge of the jump
var is_charging_jump = false  # Whether the jump is currently being charged
var jump_direction = 1  # Direction of the jump
var character_weight = 3


func _ready():
	label.text = str(damage_taken_counter)
	peak_height = global_position.y


func _physics_process(delta):
	# Add gravity when not on the ground.
	if not is_on_floor():
		velocity.y += gravity * delta * character_weight
	else:
		# Reset horizontal velocity when landing back on the ground.
		velocity.x = 0
	
	check_fall_damage()
	
	if Input.is_action_pressed("ui_left"):
		sprite.flip_h = true
		jump_direction = -1
	elif Input.is_action_pressed("ui_right"):
		jump_direction = 1
		sprite.flip_h = false
	
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
	
	
func check_fall_damage():
	#print(global_position.y)
	if !is_on_floor():
		if peak_height > global_position.y:
			peak_height = global_position.y
	else:
		# Character has landed, we need to calculate the fall distance
		#print(peak_height, " ", global_position.y)
		var fall_distance = global_position.y - peak_height
		if fall_distance > fall_damage_threshold:
			print(fall_distance)
			# The character has fallen a distance greater than the threshold, apply damage
			# var fall_distance = global_position.y - peak_height
			damage_taken_counter += 1
			label.text = str(damage_taken_counter)

		# Whether we took damage or not, reset the peak height for the next jump/fall
		peak_height = global_position.y
		
