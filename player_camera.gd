extends Camera2D

var follow_target : CharacterBody2D

@export
var FOLLOW_SPEED = 15.0

var randomStrength: float
var shakeFade: float
var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

var last_movement
var movement

@export
var initial_direction : int

var camera_pos_x = 400
var paused : bool

func _ready() -> void:
	paused = false
	follow_target = get_tree().get_first_node_in_group("Player")
	follow_target.camera_shake.connect(_on_camera_shake)
	last_movement = initial_direction

func _process(delta: float) -> void:
	#zoom = Vector2(0.6,0.6)
	if not paused:
		var movement = Input.get_axis('ui_left','ui_right')
		
		#player falling
		#if drag_bottom_margin:
			#print("falling")
			#FOLLOW_SPEED = 15.0
		#
		##player moving
		#if Input.is_action_pressed('ui_left') or Input.is_action_pressed('ui_right'):
			#if FOLLOW_SPEED < 15.0:
				#FOLLOW_SPEED += 1.0
		#
		##player on ground and not moving
		#if Input.is_action_just_released('ui_left') or Input.is_action_just_released('ui_right') and (global_position.y - follow_target.global_position.y) < 100:
			#print("just released")
			#FOLLOW_SPEED = 1.0
		#make the fall speed faster???
		#(global_position.y - follow_target.global_position.y) > 100
		if movement != 0:
			last_movement = movement
		#position_smoothing_speed
		#figure out a way to add 100 to y when falling
		if not follow_target.onWall:
			global_position = lerp(self.global_position, follow_target.global_position + Vector2(last_movement * camera_pos_x,0), delta * FOLLOW_SPEED)
		else:
			global_position = lerp(self.global_position, follow_target.global_position, delta * FOLLOW_SPEED)
		#make camera be slightly ahead of player
		randomStrength = 2.0
		shakeFade = 0.5

		if shake_strength > 0:
				shake_strength = lerpf(shake_strength,0,shakeFade * delta)
				offset = randomOffset()

func apply_shake():
	shake_strength = randomStrength
	
func randomOffset():
	return Vector2(rng.randf_range(-shake_strength,shake_strength),
	rng.randf_range(-shake_strength + (offset.y),shake_strength + (offset.y)))

func _on_camera_shake():
	apply_shake()
