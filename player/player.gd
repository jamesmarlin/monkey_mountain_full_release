class_name Player
extends CharacterBody2D

signal camera_shake

@onready
var state_macine = $state_machine

@onready
var walljump_raycast = $walljump_raycast

@onready
var animations = $animations

@onready
var particle_land_left = preload("res://particles/particle_path_left.tscn")
var land_left_instance
@onready
var land_left_marker = $land_particle_left_marker

@onready
var particle_land_right = preload("res://particles/particle_path_right.tscn")
var land_right_instance
@onready
var land_right_marker = $land_particle_right_marker

@onready
var move_particle_path = $star_particle

@onready
var particle_jump_path = preload("res://particles/particle_jump_path.tscn")
var particle_jump_instance
@onready
var particle_jump_marker = $animations/jump_particle

#@onready
#var particle_jump_path = $particle_jump_path

#@onready
#var particle_jump_path_follow = $particle_jump_path/PathFollow2D

@onready
var vine_area = $vine

@onready
var punch_area = $player_punch
var punch_area_pos
@onready
var punch_collision = $punch_collision

@onready
var hurt_area = $hurt

@onready
var bounce_collision = $player_bounce

@onready
var jump_force: float = 600.0

@export
var slide_speed: int = 0

@export
var jump_height : float
@export
var jump_time_to_peak : float
@export
var jump_time_to_descent : float
@export
var can_enter : bool

@onready
var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready
var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready
var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@onready
var onVine : bool
@onready
var onWall : bool

@onready
var vineNode : RigidBody2D

var last_saved_movement : int
var in_wall_jump_state : bool = false

var paused : bool
var not_hurt : bool


@export var health : int

@export
var death_state: State

@export
var curr_level : String

@export
var in_start_of_level : bool
@export
var debug : bool

@onready var jump_sound = $jump_audio

#@onready
#var camera : Camera2D = $player_camera

func _ready() -> void:
	animations.get_material().set_shader_parameter("death",false)
	if in_start_of_level or debug:
		GameManager.curr_level = curr_level
		GameManager.newest_spawn_point = ""
		GameManager.set_default_player_health()
		GameManager.save_curr_coin_count(GameManager.curr_coin_count)
		#GameManager.start_of_level_transition()
	else:
		#GameManager.set_default_player_health()
		#health = GameManager.get_curr_health()
		GameManager.set_curr_health(GameManager.player_health)
	state_macine.init(self)
	$player_punch/Sprite2D.visible = false
	punch_area_pos = punch_area.position.x
	paused = false
	not_hurt = true
	land_left_instance = particle_land_left.instantiate()
	land_left_instance.global_position = land_left_marker.global_position
	get_parent().add_child.call_deferred(land_left_instance)
	
	land_right_instance = particle_land_right.instantiate()
	land_right_instance.global_position = land_right_marker.global_position
	get_parent().add_child.call_deferred(land_right_instance)
	
	particle_jump_instance = particle_jump_path.instantiate()
	particle_jump_instance.global_position = particle_jump_marker.global_position
	get_parent().add_child.call_deferred(particle_jump_instance)

func _unhandled_input(event: InputEvent) -> void:
	if not paused:
		state_macine.process_input(event) 

func _physics_process(delta: float) -> void:
	if not paused:
		state_macine.process_physics(delta)

func _process(delta: float) -> void:
	if not paused:
		state_macine.process_frame(delta)
		$animations.scale.x = move_toward($animations.scale.x,0.2, 1 * delta)
		$animations.scale.y = move_toward($animations.scale.y,0.2, 1 * delta)
		var direction = Input.get_axis('ui_left','ui_right')
		# in_wall_jump_state bool instead of rewriting due to this state having
		# a special case with the player sprite direction
		if Input.is_action_just_pressed("ui_right"):
			if not in_wall_jump_state:
				punch_area.rotation_degrees = 0
				punch_area.scale.y = direction
				walljump_raycast.scale.y = direction
				animations.flip_h = true
				#NOT WORKIN
				punch_area.position.x = punch_area_pos
			#it might be instance?
			particle_jump_instance.scale.x = direction
		if Input.is_action_just_pressed("ui_left"):
			if not in_wall_jump_state:
				animations.flip_h = false
				punch_area.rotation_degrees = 180
				punch_area.scale.y = direction
				walljump_raycast.scale.y = direction
				#NOT WORKIN
				punch_area.position.x = -punch_area_pos
			particle_jump_instance.scale.x = direction

#signal for when punch touches an object in the enemy group,
#play freeze frame

func _on_punch_body_entered(body: Node2D) -> void:
		#add camera shake
		#body.hit(direction that player is facing)
		#if $animations.flip_h == true:
			#body.hit(1)
		#else:
			#body.hit(-1)
		#punch_off()
	if not body.is_in_group("boulders"):
		camera_shake.emit()

func framefreeze(timeScale,duration):
	Engine.time_scale = timeScale
	var timer = get_tree().create_timer(duration * timeScale)
	await timer.timeout
	Engine.time_scale = 1.0
	return true

func punch_on():
	#call_deferred(punch_area.monitoring,true)
	#await animations.frame == 1
	#punch_area.set_deferred("monitoring",true)
	animations.play("punch_fast")
	#NOTE, punch_collision is playing the states for punch
	punch_collision.play("punch")
	#rethink how the punch works. there's a slight delay after the punch
	#await animations.animation_finished
	#var time = get_tree().create_timer(0.2)
	#await time.timeout
	#punch_off()

#func punch_off():
	##call_deferred(punch_area.monitoring, false)
	##punch_area.monitoring = false
	#punch_area.set_deferred("monitoring",false)

func hurt():
	await framefreeze(0.5, 0.2)
	#hurt_area.set_deferred("monitorable", false)
	var tween = create_tween()
	tween.set_loops(5)
	tween.tween_property(animations,"modulate:a",0.5,0.3)
	tween.tween_property(animations,"modulate:a",1,0.3)
	await tween.finished
	#hurt_area.set_deferred("monitorable", true)
	not_hurt = true

func _on_hurt_body_entered(body: Node2D) -> void:
	#animations.get_material().set_shader_parameter("flash_enabled", true)
	#$flash_timer.start()
	#change I 
	if body.name != "player_boulder" and not_hurt:
		not_hurt = false
		GameManager.player_health -= 1
		#print("Curr Health", health)
		GameManager.set_curr_health(GameManager.player_health)
		$hurt_audio.play()
		if GameManager.player_health > 0:
			animations.modulate = Color(18.892, 18.892, 18.892, 1.0)
			var timer = get_tree().create_timer(0.1)
			await timer.timeout
			animations.modulate = Color(1.0, 1.0, 1.0, 1.0)
			hurt()

func _on_hurt_area_entered(area: Area2D) -> void:
	if area.name != "player_boulder_punch" and area.name != "hit_detection" and not_hurt:
		not_hurt = false
		GameManager.player_health -= 1
		#print("Curr Health", health)
		GameManager.set_curr_health(GameManager.player_health)
		$hurt_audio.play()
		if GameManager.player_health > 0:
			animations.modulate = Color(18.892, 18.892, 18.892, 1.0)
			var timer = get_tree().create_timer(0.1)
			await timer.timeout
			animations.modulate = Color(1.0, 1.0, 1.0, 1.0)
			hurt()

func _on_flash_timer_timeout() -> void:
	#change I
	animations.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_next_level_detector_area_entered(area: Area2D) -> void:
	if area.name == "next_level_door":
		GameManager.set_curr_health(GameManager.player_health)
	if area.name == "end_of_level_door":
		await get_tree().create_timer(0.3).timeout
		#GameManager.set_default_player_health()

func _on_item_pickup_area_entered(area: Area2D) -> void:
	if area.name == "health_item":
		$food_audio.play()
		if GameManager.player_health < 3:
			GameManager.player_health += 1
			GameManager.set_curr_health(GameManager.player_health)
	if area.name == "coin_item":
		$coin_audio.play()
		GameManager.update_coin_count()
	if area.name == "big_coin_item":
		$big_coin_audio.play()
		GameManager.update_big_coin_count(curr_level)
