extends Path2D

signal death

@export var move_speed : float = .005

@export var speed_scale = 1.0
@onready var birrd_fly = $birrd_fly_path_follow_2d
@onready var birrd_fly_body = $birrd_fly_path_follow_2d/birrd_fly_body
@onready var direction = 1

@export
var is_loop : bool

@onready var animation = $AnimationPlayer

func _ready() -> void:
	if is_loop:
		birrd_fly.loop = true
	else:
		animation.play("move")
		animation.speed_scale = speed_scale
		set_process(false)
	birrd_fly.rotation_degrees = 0.0
	birrd_fly_body.birrd_fly_death.connect(on_birrd_fly_death)
	birrd_fly_body.birrd_fly_movement_cancel.connect(on_birrd_fly_cancel)
func _process(delta: float) -> void:
	birrd_fly.progress_ratio += move_speed * direction
	if birrd_fly.progress_ratio == 1 or birrd_fly.progress_ratio == 0:
		direction *= -1

func on_birrd_fly_death():
	#death.emit()
	self.queue_free()

func on_birrd_fly_cancel():
	set_process(false)
