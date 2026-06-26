extends State

@export
var fall_state: State

@export
var vine_state: State
@export
var death_state: State

var jump_lockout : float = 0.0

func enter() -> void:
	#lock the animations direction based on state
	super()
	parent.jump_sound.play()
	parent.particle_jump_instance.global_position = parent.particle_jump_marker.global_position
	parent.particle_jump_instance.start()
	jump_lockout = 0.40
	parent.animations.scale.x = 0.25
	parent.animations.scale.y = 0.15
	#star not pointing the right direction
	#most likely because position is locked
	#parent.particle_jump_instance.global_position = parent.particle_jump_marker.global_position
	#parent.particle_jump_instance.start()

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	
	if Input.is_action_just_pressed("punch_action"):
		parent.punch_on()

	if parent.velocity.y < 0.0:
		parent.velocity.y += parent.jump_gravity * delta
	
	jump_lockout -= delta

	if parent.onVine:
		return vine_state

	if jump_lockout < 0.0:
		return fall_state
		
	if GameManager.player_health <= 0:
		return death_state
	return null

func process_frame(delta: float) -> State:
	return null

func exit() -> void:
	parent.in_wall_jump_state = false
