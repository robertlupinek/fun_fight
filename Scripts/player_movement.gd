extends CharacterBody2D

@export var ground_speed : float = 1000.0
@export var air_speed : float = 500.0
@export var jump_velocity : float = -250.0
@export var max_velocity : float = 150.0
@export var ground_friction : float = 24.0
@export var air_friction : float = 7.0
@export var wall_jump_velocity_x = 350
# Current Speed
var speed: float = ground_speed
# Current horizontal friction.  Changes based on state of playing 
var friction : float = ground_speed
var direction : float
var facing : float = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
# Configure jumping
var coyote_timer = Timer.new()
@export var coyote_delay : float = 0.1
var landed : bool = false
# Double jump and so on :)
@export var extra_jumps : int = 1
var current_extra_jumps = extra_jumps

# Called when the node enters the scene tree for the first time.
func _ready():
	coyote_timer.one_shot = true
	coyote_timer.start(coyote_delay)
	add_child(coyote_timer)

func _physics_process(delta):
	
	# Player State
	
	## Handle all changes required for when landing on the floor or being midair.
	if not is_on_floor():
		## Midair
		## Add the gravity.
		velocity.y += gravity * delta
		speed = air_speed
		friction = air_friction
		landed = false
	else:
		## On floor
		speed = ground_speed
		friction = ground_friction
		## Reset extra jumps count
		current_extra_jumps = extra_jumps
		## Do thing when you just landed for the first time.
		if landed == false:
			var asdf = 1
		landed = true
		## Start the coyote time to indicate you can now jump
		coyote_timer.start(coyote_delay)
		
	## On wall
	if is_on_wall():
		## Allow wall jump
		coyote_timer.start(coyote_delay)
		## Reset extra jumps count
		current_extra_jumps = extra_jumps
		if direction != 0:
			if velocity.y > 30:
				velocity.y = 30
		
	# Horizontal movement
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	## Get the direction the player is facing
	if direction != 0:
		facing = direction
	
	if direction:
		velocity.x += direction * speed * delta
	## Applying horizontal friction always redcucing speed vs when not moving.  Uncomment `else` only apply friction when not moving.
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
	## Keep x velocity from going over max velocity
	if abs(velocity.x) > max_velocity:
		velocity.x = max_velocity * sign(velocity.x)

	# Handle jumping.  
	
	## We use a "coyote" timer to determine when you can jump vs if on ground.
	if Input.is_action_just_pressed("ui_accept") and ( not coyote_timer.is_stopped() or current_extra_jumps > 0 ):
		## Only count the jump as a "double" or "tripple" or more jump IF the coyote timer has stopped indicating you are not on the ground.
		if coyote_timer.is_stopped():
			current_extra_jumps -= 1
		velocity.y = jump_velocity
		# Play the jump sound
		$SoundPlayer.play()

		## Wall jump off the wall a bit.  Make sure we are also not on the floor.  This would be weird trying to jump over walls and just bouncing back.
		if is_on_wall() and not is_on_floor():
			velocity.x = wall_jump_velocity_x * -direction 
		## Stop the coyote timer
		coyote_timer.stop()
	## Release jump button
	if Input.is_action_just_released("ui_accept"):
		if velocity.y < 0:
			velocity.y = velocity.y * 0.4

	# Jump down
	if Input.is_action_just_pressed("ui_down"):
		if is_on_floor():
			position.y +=1
		
	# Handle physics
	move_and_slide()
	
	# Check for moving outside of play boundaries
	if position.y > 1524:
		_the_ending()
		
	# Debug info
	

	
func _the_ending():
	get_tree().change_scene_to_file('res://Scenes/1st.tscn')
