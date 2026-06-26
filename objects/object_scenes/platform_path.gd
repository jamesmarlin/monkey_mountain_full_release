extends Path2D

@export var loop = true
@export var speed = 2.0
@export var speed_scale = 1.0
@export var one_way : bool
@export var touch_to_start : bool
@export var is_active = true

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer
@export var platform_type : AnimatedSprite2D

@export var spike : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	#var l := Line2D.new()   
	#l.default_color = Color(0.89, 0.0, 0.118, 1.0) 
	#l.width = 20  
	#for point in self.curve.get_baked_points():
		#l.add_point(point + path.position)
	if spike:
		is_active = true
	if not spike:
		if one_way:
			platform_type.frame = 1
		else:
			platform_type.frame = 0
	if is_active:
		if not loop:
			animation.play("move")
			animation.speed_scale = speed_scale
			set_process(false)
	if not is_active:
		set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if one_way:
		path.progress += speed
		if path.progress_ratio >= 0.95:
			#loop = false
			set_process(false)
			#path.progress_ratio = 1.0
	else:
		path.progress += speed

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if one_way:
			if path.progress_ratio <= 0.95:
				set_process(true)
		if touch_to_start and not is_active:
			#turn off animation looping
			is_active = true
			animation.play("move_one_way")
			animation.speed_scale = speed_scale

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if one_way:
			set_process(false)
