extends Node2D

var simple_player = preload("res://Option A/player_a.tscn")
var intermediate_player = preload("res://Option B/player_b.tscn")
var lord_of_state_machines_player = preload("res://Option C/player_c.tscn")

enum Player_Type {A,B,C}

@export var who_to_load = Player_Type.A

func _ready() -> void:
	var player_loaded
	
	match who_to_load:
		Player_Type.A:
			player_loaded = simple_player
		Player_Type.B:
			player_loaded = intermediate_player
		Player_Type.C:
			player_loaded = lord_of_state_machines_player
			
	add_child(player_loaded.instantiate())
	
