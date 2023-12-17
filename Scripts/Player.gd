extends CharacterBody2D

const MAX_JUMP_VELOCITY = -1500.0  # Maximum jump velocity
const MIN_JUMP_VELOCITY = -200.0  # Minimum jump velocity for a short press
const MAX_CHARGE_TIME = 1.0       # Maximum time the jump can be charged
const JUMP_HORIZONTAL_SPEED = 1000.0  # Horizontal speed during jump

@export var trajectory_line: Line2D
@export var label: Label
@export var animation: AnimationPlayer
@export var body: Polygon2D
@export var nose: Polygon2D
@export var skeleton: Node2D
@export var spawn: Node2D
@export var death_sound: AudioStreamPlayer
@export var finish: Area2D
@export var end_timer: Timer

var is_end = false
var broken_scene = preload("res://Scenes/broken.tscn")
var broken_instance
var isLeft = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# damage
var peak_height = 0
var fall_damage_threshold = 850
var damage_taken_counter = 0

# jump parameter
var jump_charge = 0.0  # Current charge of the jump
var is_charging_jump = false  # Whether the jump is currently being charged
var jump_direction = 1  # Direction of the jump
var character_weight = 3


func _ready():
	label.text = str(damage_taken_counter)
	peak_height = global_position.y
	finish.body_entered.connect(_on_FinishArea_body_entered)
	# Connect the Timer's timeout signal to the respawn function
	# Connect the Timer's timeout signal to the respawn function
	var timer = get_node("RespawnTimer")  # Adjust the path if necessary
	timer.timeout.connect(respawn)
	end_timer.timeout.connect(restart)


func _physics_process(delta):
	# Add gravity when not on the ground.
	if not is_on_floor():
		velocity.y += gravity * delta * character_weight
	else:
		# Reset horizontal velocity when landing back on the ground.
		velocity.x = 0

	check_fall_damage()

	# Handle character flipping and position adjustment for left/right movement
	if Input.is_action_pressed("ui_left"):
		flip_character(-1)
		jump_direction = -1
		if Input.is_action_just_pressed("ui_left") and !isLeft:
			adjust_character_position_for_left()
	elif Input.is_action_pressed("ui_right"):
		flip_character(1)
		jump_direction = 1
		if Input.is_action_just_pressed("ui_right") and isLeft:
			adjust_character_position_for_right()

	# Handle jump charging.
	if Input.is_action_pressed("ui_accept"):
		if is_on_floor():
			is_charging_jump = true
			animation.play("jump_right")
			jump_charge += delta
			if jump_charge > MAX_CHARGE_TIME:
				jump_charge = MAX_CHARGE_TIME
	elif is_charging_jump:
		# Jump is released, execute the jump
		execute_jump()

	# If not charging jump and animation is playing, stop the animation
	if not is_charging_jump and animation.is_playing():
		animation.stop()

	# Apply movement.
	move_and_slide()

func flip_character(direction):
	body.scale.x = direction
	nose.scale.x = direction

func adjust_character_position_for_left():
	isLeft = true
	body.position.x += 660
	nose.position.x += 1370

func adjust_character_position_for_right():
	isLeft = false
	body.position.x -= 660
	nose.position.x -= 1370

func execute_jump():
	var jump_strength = lerp(MIN_JUMP_VELOCITY, MAX_JUMP_VELOCITY, jump_charge / MAX_CHARGE_TIME)
	velocity.y = jump_strength
	velocity.x = JUMP_HORIZONTAL_SPEED * jump_direction
	is_charging_jump = false
	jump_charge = 0.0

	
	
func check_fall_damage():
	#print(global_position.y)
	if !is_on_floor():
		if peak_height > global_position.y:
			peak_height = global_position.y
	else:
		# Character has landed, we need to calculate the fall distance
		#print(peak_height, " ", global_position.y)
		var fall_distance = global_position.y - peak_height
		if fall_distance > fall_damage_threshold && not is_end:
			print(fall_distance)
			# The character has fallen a distance greater than the threshold, apply damage
			# var fall_distance = global_position.y - peak_height
			death()
			label.text = str(damage_taken_counter)

		# Whether we took damage or not, reset the peak height for the next jump/fall
		peak_height = global_position.y
		
func death():
	broken_instance = broken_scene.instantiate()
	add_child(broken_instance)
	broken_instance.global_position = global_position
	skeleton.visible = false
	death_sound.play()
	# Disable processing and physics processing
	set_process(false)
	set_physics_process(false)

	# Start the respawn timer
	var timer = get_node("RespawnTimer")  # Replace "Timer" with the correct path if needed
	timer.start()


func respawn():
	global_position = spawn.global_position
	skeleton.visible = true
	remove_child(broken_instance)

	# Re-enable processing and physics processing
	set_process(true)
	set_physics_process(true)


func _on_FinishArea_body_entered(body):
	is_end = true
	end_timer.start()
	


func restart():
	get_tree().change_scene_to_file("res://Scenes/EndParty.tscn")
