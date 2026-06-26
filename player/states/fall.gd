extends State

@export
var jump_buffer_time : float = 0.1
@export
var idle_state: State
@export
var move_state: State
@export
var grab_state: State
@export
var vine_state: State
@export
var jump_state: State
@export
var death_state: State

var vineNode : Node2D

var jump_buffer_timer : float = 0.0

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	super()
	jump_buffer_timer = 0.0
	
	parent.bounce_collision.call_deferred("set_monitorable",true)
	parent.bounce_collision.call_deferred("set_monitoring",true)

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("ui_up"):
		jump_buffer_timer = jump_buffer_time
	if Input.is_action_just_pressed("punch_action"):
		parent.punch_on()
	return null

func process_frame(delta: float) -> State:
	jump_buffer_timer -= delta
	return null

func process_physics(delta: float) -> State:
	var movement = Input.get_axis('ui_left','ui_right') * move_speed
	parent.move_and_slide()
	parent.velocity.y += parent.fall_gravity * delta

	if GameManager.player_health <= 0:
		return death_state
	#if not Input.is_action_pressed("ui_down"):
		#parent.set_collision_mask_value(4,true)
	
	parent.velocity.x = movement
	if movement > 0:
		parent.animations.flip_h = true
	if movement < 0:
		parent.animations.flip_h = false

	if parent.is_on_floor():
		#if parent.animations.flip_h == true:
			#parent.particle_path.scale.x = -1
		#else:
			#parent.particle_path.scale.x = 1
		#parent.particle_path_follow.choose_frame("jump_land")
		#parent.particle_path_follow_right.choose_frame("jump_land")
		if jump_buffer_timer > 0:
			return jump_state
		parent.land_left_instance.global_position = parent.land_left_marker.global_position
		parent.land_left_instance.start()
		
		parent.land_right_instance.global_position = parent.land_right_marker.global_position
		parent.land_right_instance.start()
		if movement == 0:
			return idle_state
		return move_state
	
	if parent.walljump_raycast.is_colliding() or parent.walljump_raycast.is_colliding():
		if parent.walljump_raycast.get_collider() != null:
			if parent.walljump_raycast.get_collider().name == "rope":
				parent.vineNode = parent.walljump_raycast.get_collider()
				parent.onVine = true
		if parent.walljump_raycast.get_collider() != null:
			if parent.walljump_raycast.get_collider().name == "rope":
				parent.vineNode = parent.walljump_raycast.get_collider()
				parent.onVine = true
		parent.last_saved_movement = parent.walljump_raycast.scale.y * -1
		return grab_state

	if parent.onVine:
		return vine_state

	return null
	

func exit() -> void:
	parent.bounce_collision.call_deferred("set_monitorable",false)
	parent.bounce_collision.call_deferred("set_monitoring",false)
