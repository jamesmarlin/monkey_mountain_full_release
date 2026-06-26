extends State

@export
var jump_state: State
@export
var move_state: State
@export
var punch_state: State
@export
var death_state: State


var in_idle: bool

func enter() -> void:
	super()
	parent.velocity.x = 0
	#parent.animations.scale.y = 0.15

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("ui_up") and parent.is_on_floor():
		parent.velocity.y = parent.jump_velocity
		return jump_state
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		return move_state
	if Input.is_action_just_pressed("punch_action"):
		return punch_state
	return null

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	parent.velocity.y += gravity * delta

	if !parent.is_on_floor():
		return jump_state
	
	if GameManager.player_health <= 0:
		return death_state
	return null

func process_frame(delta: float) -> State:
	return null
