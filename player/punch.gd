extends State

@export
var idle_state: State
@export
var grab_state: State
@export
var jump_state: State
@export
var move_state: State
@export
var fall_state: State
@export
var death_state: State

var wall_jump_lockout := 0.0

var punch_ani_finished : bool = false

func enter():
	super()
	parent.hurt_area.set_deferred("monitorable", false)
	punch_ani_finished = false
	parent.punch_collision.play("punch")
	#just play punch animation??
	wall_jump_lockout = 0.15

func process_physics(delta: float) -> State:
	var movement = Input.get_axis('ui_left','ui_right') * move_speed
	parent.velocity.y += parent.jump_gravity * delta
	
	if wall_jump_lockout > 0:
		wall_jump_lockout -= delta
	
	if parent.is_on_floor() and punch_ani_finished:
		if movement == 0:
			return idle_state
		return move_state

	#are you grabbing
	if wall_jump_lockout <= 0 and (parent.walljump_raycast.is_colliding() or parent.walljump_raycast.is_colliding()):
		return grab_state
		
	if !parent.is_on_floor() and !Input.is_action_just_pressed("ui_up") and punch_ani_finished:
		return fall_state
		
	if GameManager.player_health <= 0:
		return death_state
	
	parent.move_and_slide()
	return null

func process_frame(delta: float) -> State:
	return null

func _on_animations_animation_finished() -> void:
	punch_ani_finished = true

func exit() -> void:
	parent.hurt_area.set_deferred("monitorable", true)
