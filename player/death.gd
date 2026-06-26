extends State

@export
var idle_state: State

func enter() -> void:
	super()
	#confirm if player walked through spawn point,
	#if so, send scene transition the correct scene
	#parent.gamemanager.game_over()
	##if spawn_point_scene != null:
	parent.animations.stop()
	parent.animations.get_material().set_shader_parameter("death",true)
	BackgroundMusic.stop()
	#await parent.framefreeze(0.5, 1.0)
		#SceneTransition.game_over_transition(spawn_point_scene)
	#else:
	if GameManager.newest_spawn_point != "":
		#from spawn point
		GameManager.game_over_transition(GameManager.newest_spawn_point)
		GameManager.set_big_coin_count()
	else:
		#reset big coins here
		#beginning of level
		GameManager.reset_big_coin_count(parent.curr_level)
		GameManager.game_over_transition(parent.curr_level)
	#parent.paused = true

#func process_physics(delta: float) -> State:
	##resetting health for testing
	##
	#parent.global_position = spawn_point_pos
	#
	#return idle_state
