extends Node

@export
var starting_state: State

var current_state: State

@export
var death_state: State
@export
var jump_state: State

var bounce = false

var parent = Player
#	give each child state a ref to the parent object it belongs to
#	and enter the default starting_state
func init(parent: Player) -> void:
	for child in get_children():
		child.parent = parent
	#initialize default state
	change_state(starting_state)
	
#	change current stage but first calling any exit logic on the current state
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()

#	pass through functions for the Player to call,
# 	handling state changes as needed
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

func _on_spawn_point_detector_area_entered(area):
	if area.name == "spawn_point":
		GameManager.newest_spawn_point = area.spawn_point_loc
		GameManager.save_curr_coin_count(GameManager.curr_coin_count)
		GameManager.save_curr_big_coin_count()

func _on_bounce_area_area_entered(area: Area2D) -> void:
	if area.name == "bounce":
		bounce = true
		change_state(jump_state)

func _on_death_detection_body_entered(body: Node2D) -> void:
	change_state(death_state)
