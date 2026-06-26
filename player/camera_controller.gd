extends Node2D
var player_loc

func get_loc(_player_loc):
	player_loc = _player_loc

func _process(delta):
	global_position = player_loc
