extends Path2D

signal death
@onready var leaper = $leaper_path_follow_2d/RemoteTransform2D
@onready var detection_up = $player_detection_up
@onready var detection_angle = $player_detection_angle
@onready var direction = 1

@onready var leap : bool = false

@onready var is_active : bool = false

@export var detection_up_on : bool
@export var detection_angle_on : bool
@export var move_speed : float = .005

#can be up or down
@export var leaper_type : String
@export var reach_to_start : bool

@onready var animation = $AnimationPlayer
@export var speed_scale = 1.0
#var points_list = []
#var point_count

func _ready() -> void:
	$leap_body.leaper_death.connect(on_leaper_death)
	$leap_body.leaper_movement_cancel.connect(on_leaper_movement_cancel)
	#point_count = self.curve.get_point_count()
	#for num in range(point_count):
		#points_list.append(self.curve.get_point_position(num))
	#^ use this info to play around with speeds of leaper
	#if detection_up_on:
		#detection_up.set_deferred("monitoring",true)
	#if detection_angle_on:
		#detection_angle.set_deferred("monitoring",true)
	#leaper.rotation_degrees = 0.0

#func _process(delta: float) -> void:
	##if leap:
	##use enemy trigger for activating leaper!!
		##leaper.progress_ratio += move_speed * direction
		##if up
		#if leaper.progress_ratio == 1:
			#is_active = false
			#leaper.progress_ratio = 0
			#if reach_to_start:
				#$Timer.start()
		#else (angle)
		#if detection_up_on:
			#if leaper.progress_ratio == 1 or leaper.progress_ratio == 0:
				#direction *= -1
		#if leaper.progress_ratio == 1 or leaper.progress_ratio == 0:
			#direction *= -1
			#leap = false
func _on_player_detection_up_body_entered(body: Node2D) -> void:
	leap = true

func _on_player_detection_angle_body_entered(body: Node2D) -> void:
	leap = true

func on_leaper_death():
	self.queue_free()

func on_leaper_movement_cancel():
	#animation bezier curve for both directions
	#pass in dir of player to this signal to play the correct bezier curve animation
	$Timer.stop()
	animation.stop()
	leaper.update_position = false
	var hit_position = $leap_body.global_position
	$leap_body.global_position = hit_position
	#animation.reset_on_save = false

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	#if is_active:
	animation.play("move")
	animation.speed_scale = speed_scale
	#set_process(false)

func _on_timer_timeout() -> void:
	#is_active = true
	animation.play("move")
	animation.speed_scale = speed_scale

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$Timer.start()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#animation.stop()
	$Timer.stop()
