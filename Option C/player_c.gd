extends CharacterBody2D

# NOTE, gliding state hasnt been added yet here, it's just Idle, Run, and Air state.
var ground_speed := 700.0
var air_speed := 300.0

var jump_impulse := 1200.0
var base_gravity := 4000.0

#var glide_max_speed := 1000.0
#var glide_acceleration := 1000.0
#var glide_gravity := 1000.0
#var glide_jump_impulse := 500.0

var gravity := 4000.0
