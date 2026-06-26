extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var move_state: State
@export
var grab_state: State
@export
var vine_state: State
@export
var punch_state: State
@export
var death_state: State

var wall_jump_lockout := 0.0
var extra_bounce : bool
var in_jump : bool

var jump_released : bool

var curr_left_collision : String
var curr_right_collision : String

func enter() -> void:
	super()
	parent.jump_sound.play()
	parent.particle_jump_instance.global_position = parent.particle_jump_marker.global_position
	parent.particle_jump_instance.start()
	#parent.particle_jump_instance.particle_jump_path_follow.choose_frame("jump_land")
	extra_bounce = get_parent().bounce
	if extra_bounce:
		#parent.particle_jump_path_follow.choose_frame("jump_land")
		#parent.particle_jump_instance.global_position = parent.particle_jump_marker.global_position
		#parent.particle_jump_instance.start()
		parent.velocity.y = parent.jump_velocity - 100
		get_parent().bounce = false
		extra_bounce = false
	wall_jump_lockout = 0.15
	in_jump = true
	jump_released = false
	parent.animations.scale.y = 0.3

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("punch_action"):
		return punch_state
	if Input.is_action_just_released("ui_up"):
		jump_released = true
	return null
 
func process_physics(delta: float) -> State:
	parent.move_and_slide()
	#print("Current: Velocity: ", parent.velocity.y)
	var movement = Input.get_axis('ui_left','ui_right') * move_speed
	if wall_jump_lockout > 0:
		wall_jump_lockout -= delta

	parent.velocity.x = movement

	if movement > 0:
		parent.animations.flip_h = true
	if movement < 0:
		parent.animations.flip_h = false

	if parent.velocity.y < 0.0 and not jump_released:
		parent.velocity.y += parent.jump_gravity * delta
	else:
		#parent.velocity.y += parent.fall_gravity * delta
		return fall_state
		
	if GameManager.player_health <= 0:
		return death_state

	if parent.is_on_floor():
		#signal to play animation based on direction of sprite
		#if parent.animations.flip_h == true:
			#parent.particle_path.scale.x = -1
		#else:
			#parent.particle_path.scale.x = 1
		#parent.particle_path_follow.choose_frame("jump_land")
		#parent.particle_path_follow_right.choose_frame("jump_land")
		parent.land_left_instance.global_position = parent.land_left_marker.global_position
		parent.land_left_instance.start()
		
		parent.land_right_instance.global_position = parent.land_right_marker.global_position
		parent.land_right_instance.start()
		if movement == 0:
			return idle_state
		return move_state

	if wall_jump_lockout <= 0 and parent.walljump_raycast.is_colliding():
		parent.last_saved_movement = parent.walljump_raycast.scale.y * -1
		return grab_state

	if parent.onVine:
		return vine_state

	return null

func process_frame(delta: float) -> State:
	return null

func exit() -> void:
	in_jump = false

func _on_vine_body_entered(body: Node2D) -> void:
	if body.name == "rope_body":
		parent.vineNode = body
		parent.onVine = true
