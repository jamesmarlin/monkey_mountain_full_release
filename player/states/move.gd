extends State

@export
var fall_state: State
@export
var jump_state: State
@export
var idle_state: State
@export
var punch_state: State
@export
var death_state: State

func enter() -> void:
	super()
	parent.move_particle_path.emitting = true
	#parent.animations.scale.x = 0.25
	#parent.animations.scale.y = 0.15
	#parent.particle_path_follow.choose_frame("move")

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("ui_up") and parent.is_on_floor():
		parent.velocity.y = parent.jump_velocity
		return jump_state
	#if Input.is_action_pressed("ui_down"):
		#parent.set_collision_mask_value(4,false)
		#return fall_state
	if Input.is_action_just_pressed("punch_action"):
		return punch_state
	return null

func process_physics(delta: float) -> State:
	parent.move_and_slide()
		#parent.punch_on()
	parent.velocity.y += gravity * delta
	
	if GameManager.player_health <= 0:
		return death_state
	var movement = Input.get_axis('ui_left','ui_right') * move_speed
	parent.velocity.x = movement
	if movement > 0:
		parent.animations.flip_h = true
	if movement < 0:
		parent.animations.flip_h = false

	if movement == 0:
		return idle_state

	if !parent.is_on_floor() and !Input.is_action_just_pressed("ui_up"):
		return fall_state

	return null
	
func process_frame(delta: float) -> State:
	return null

func exit() -> void:
	parent.move_particle_path.emitting = false
