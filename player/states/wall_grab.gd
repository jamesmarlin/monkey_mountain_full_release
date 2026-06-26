extends State

@export
var fall_state: State
@export
var jump_state: State
@export
var idle_state: State
@export
var wall_jump_state: State
@export
var vine_state: State
@export
var death_state: State

@export
var wall_jump_height = 800
#var last_saved_movement 

var jump_lockout := 0.0
var slide_lockout := 0.0

func enter() -> void:
	super()
	parent.onWall = true
	slide_lockout = 0.20
	jump_lockout = 2.0
	parent.in_wall_jump_state = true
	parent.animations.scale.x = 0.25
	parent.animations.scale.y = 0.15
	#if parent.onVine:
		#parent.reparent(parent.vineNode)
		#parent.rotation_degrees = 0
		#parent.global_position = parent.vineNode.global_position
		#parent.velocity = Vector2.ZERO

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	#should already have the last saved movement
	parent.move_and_slide()
	slide_lockout -= delta
	if slide_lockout < 0.0:
		parent.velocity.y = clamp(parent.velocity.y, parent.fall_gravity, parent.slide_speed)
	else:
		parent.velocity.y = clamp(parent.velocity.y, parent.fall_gravity, 0.0)

	if parent.is_on_floor():
		return idle_state
	
	if parent.onVine:
		return vine_state
	
	if GameManager.player_health <= 0:
		return death_state
	#var movement = Input.get_axis('ui_left','ui_right')

	#if (movement > 0) and parent.walljump_raycast.is_colliding():
		#parent.animations.flip_h = true
	#if (movement < 0) and parent.walljump_raycast.is_colliding():
		#parent.animations.flip_h = false
	#if movement != 0:
		#last_saved_movement = movement
		#print(last_saved_movement)
	#add up to max slide speed??

	#wall kick
	if Input.is_action_just_pressed("ui_up"):
		#if (Input.is_action_pressed("ui_right") and parent.walljump_raycast.is_colliding()) or (Input.is_action_pressed("ui_left") and parent.walljump_raycast.is_colliding()):
		parent.velocity.y = -wall_jump_height * 2.4
		parent.velocity.x = 800 * parent.last_saved_movement
		#if jump_lockout > 0:
			#jump_lockout -= delta
		#if jump_lockout < 0:
		#variable that indicates which direction you last jumped
		#last_jump_direction
		if parent.punch_area.rotation_degrees == 180:
			parent.punch_area.rotation_degrees = 0
		else:
			parent.punch_area.rotation_degrees = 180
		parent.punch_area.scale.y = parent.punch_area.scale.y * -1
		parent.walljump_raycast.scale.y = parent.walljump_raycast.scale.y * -1
		parent.animations.flip_h = not parent.animations.flip_h
		return wall_jump_state

	if !parent.walljump_raycast.is_colliding() and !parent.walljump_raycast.is_colliding():
		return fall_state

	return null
	
func process_frame(delta: float) -> State:
	return null

func exit() -> void:
	#parent.rotation_degrees = 0
	parent.onWall = false
	parent.in_wall_jump_state = false
