extends CharacterBody2D
# OPTION A: if-else structure
var speed := 500.0
var jump_impulse := 1200.0
var base_gravity := 4000.0

# Here are the new variables for gliding.
var glide_max_speed := 1000.0
var glide_acceleration := 1000.0
var glide_gravity := 1000.0
var glide_jump_impulse := 500.0

# There's also a new boolean value to keep track of the gliding state.
var _is_gliding := false


func _physics_process(delta: float) -> void:
	# Starting with input.
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	var is_jumping := (is_on_floor() or _is_gliding) and Input.is_action_just_pressed("move_up")

	# Initiating gliding, only when the character is in the air.
	if Input.is_action_just_pressed("glide") and not is_on_floor():
		_is_gliding = true

	# canceling gliding
	if _is_gliding and Input.is_action_just_pressed("move_up"):
		_is_gliding = false

	# Calculating horizontal velocity.
	if _is_gliding:
		velocity.x += input_direction_x * glide_acceleration
		if input_direction_x == 1:
			velocity.x = min(velocity.x, glide_max_speed)
		else:
			velocity.x = max(velocity.x, -glide_max_speed)
	else:
		velocity.x = input_direction_x * speed

	# Calculating vertical velocity.
	var gravity := glide_gravity if _is_gliding else base_gravity
	velocity.y += gravity * delta
	if is_jumping:
		var impulse = jump_impulse if is_on_floor() else glide_jump_impulse
		velocity.y = -jump_impulse

	# Moving the character.
	move_and_slide()

	# If we're gliding and we collide with something, we turn gliding off and the character falls.
	if _is_gliding and get_slide_collision_count() > 0:
		_is_gliding = false
