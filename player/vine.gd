extends State

@export
var jump_state: State
@export
var death_state: State

@export
var vine_jump_height = 800

var in_vine : bool
var jump_lockout := 0.0

func enter() -> void:
	super()
	jump_lockout = 0.20
	parent.global_position = parent.vineNode.get_rope_position(parent)
	parent.reparent(parent.vineNode)
	parent.rotation_degrees = 0
	parent.velocity = Vector2.ZERO
	parent.onVine = true
	in_vine = true

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	if jump_lockout > 0:
		jump_lockout -= delta
	var movement = Input.get_axis('ui_left','ui_right')
	#needs to be a delay before you can press up
	if Input.is_action_pressed("ui_up") and in_vine and jump_lockout <= 0:
		parent.velocity.y = -vine_jump_height * 2.4
		parent.velocity.x = 800 * movement
		return jump_state
	if GameManager.player_health <= 0:
		return death_state
	if Input.is_action_pressed("ui_down"):
		parent.velocity.y = clamp(parent.velocity.y, parent.fall_gravity, parent.slide_speed)
	else:
		parent.velocity.y = 0
	return null

func process_frame(delta: float) -> State:
	return null

func exit() -> void:
	parent.vine_area.monitoring = false
	parent.onVine = false
	parent.reparent(get_tree().current_scene)
	parent.rotation_degrees = 0
	in_vine = false
	await get_tree().create_timer(0.2).timeout
	parent.vine_area.monitoring = true
