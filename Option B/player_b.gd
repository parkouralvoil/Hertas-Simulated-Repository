extends CharacterBody2D
#OPTION B: (much more similar to how our code is currently designed, 
# using states BUT with new change_state function instead of
# changing states by doing "current_state = ON_GROUND")

# An enum allows us to keep track of valid states.
enum States {ON_GROUND, IN_AIR, GLIDING}

#...
var ground_speed := 700.0
var air_speed := 300.0

var speed := ground_speed
var jump_impulse := 1200.0
var base_gravity := 4000.0

# Here are the new variables for gliding.
var glide_max_speed := 1000.0
var glide_acceleration := 1000.0
var glide_gravity := 1000.0
var glide_jump_impulse := 500.0

# With a variable that keeps track of the current state, we don't need to add more booleans.
var _state : int = States.ON_GROUND


func _physics_process(delta: float) -> void:
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	var is_jumping: bool = _state == States.ON_GROUND and Input.is_action_just_pressed("move_up")

	match _state:
		States.ON_GROUND:
			velocity.x = input_direction_x * speed

		States.IN_AIR:
			velocity.x = input_direction_x * speed
			
			# Start gliding
			if Input.is_action_just_pressed("glide"):
				change_state(States.GLIDING)
			
		States.GLIDING:
			# gliding movement
			velocity.x += input_direction_x * glide_acceleration * delta
			velocity.x = min(velocity.x, glide_max_speed)
			
			# Canceling gliding.
			if Input.is_action_just_pressed("move_up"):
				change_state(States.IN_AIR)
				
			# If we're gliding and we collide with something, we turn gliding off and the character falls.
			if get_slide_collision_count() > 0:
				change_state(States.IN_AIR)

	# Calculating vertical velocity.
	var gravity := glide_gravity if _state == States.GLIDING else base_gravity
	velocity.y += gravity * delta
	
	if is_jumping:
		var impulse = -glide_jump_impulse if _state == States.GLIDING else -jump_impulse
		velocity.y = impulse
		change_state(States.IN_AIR)

	# Moving the character.
	move_and_slide()

	if is_on_floor() and _state != States.ON_GROUND:
		change_state(States.ON_GROUND)
	print(speed)
		
		
func change_state(new_state: States) -> void:
	var previous_state := _state
	_state = new_state

	# Initialize the new state.
	# think of this as the Enter()
	# we could put the Play sound effects here, the Change hitbox sizes, etc
	match _state:
		States.ON_GROUND:
			speed = ground_speed
		States.IN_AIR:
			speed = air_speed
		States.GLIDING:
			modulate = Color(0, 1, 0)

	# Clean up the previous state. 
	# think of this as Exit()
	# we could put the Stop sound effects here, the Revert hitbox size, etc.
	match previous_state:
		States.GLIDING:
			modulate = Color(1, 1, 1)
		_:
			pass
