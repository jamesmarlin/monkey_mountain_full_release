class_name State
extends Node

@export
var animation_name: String

@export
var move_speed: float = 1000

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

#	hold a reference to the parent so it can be controlled by the state
var parent: Player

func enter() -> void:
	#in the future, this is how we play animations
	parent.animations.play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null
	
func process_frame(delta: float) -> State:
	return null
	
func process_physics(delta: float) -> State:
	return null
