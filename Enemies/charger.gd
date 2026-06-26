extends Enemy

var sprite_body
@onready var dash_circles_front_layer = $dash_circles_front_layer
@onready var dash_circles_back_layer = $dash_circles_back_layer
@onready var animation = $AnimationPlayer
@onready var hit_detection = $hit_detection
@onready var player_detection = $player_detection

func _ready() -> void:
	sprite_body = $Sprite2D
	if is_active:
		sprite_body.play("dash")
		animation.play("angry_charge")
		dash_circles_back_layer.visible = true
		dash_circles_front_layer.visible = true
	if dir == 1:
		sprite_body.flip_h = true
		player_detection.scale.x = -1
		dash_circles_back_layer.scale.x = -1
		dash_circles_front_layer.scale.x = -1
		hit_detection.scale.x = -1
	elif dir == -1:
		sprite_body.flip_h = false
		player_detection.scale.x = 1
		dash_circles_back_layer.scale.x = 1
		dash_circles_front_layer.scale.x = 1
		hit_detection.scale.x = 1

func _process(delta: float) -> void:
	if is_hit:
		rotation += 0.05
		self.position = bezier(time)
		time += (delta * 0.8)
		if time >= 2:
			self.queue_free()

func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity.y += gravity * delta
	if is_active:
		velocity.x = move_speed * dir
		sprite_body.play("dash")
		animation.play("angry_charge")
		dash_circles_back_layer.visible = true
		dash_circles_front_layer.visible = true

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		is_active = true
		if body.global_position.x < self.global_position.x:
			dir = -1
			sprite_body.flip_h = false
			player_detection.scale.x = 1
			dash_circles_back_layer.scale.x = 1
			dash_circles_front_layer.scale.x = 1
			hit_detection.scale.x = 1
		else:
			dir = 1
			sprite_body.flip_h = true
			player_detection.scale.x = -1
			dash_circles_back_layer.scale.x = -1
			dash_circles_front_layer.scale.x = -1
			hit_detection.scale.x = -1
#another signal for when it hits a wall. That's when it turns around
func _on_wall_detection_body_entered(body: Node2D) -> void:
	#is_active = false
	#flip the sprite and rotation_degrees
	dir *= -1
	sprite_body.flip_h = !sprite_body.flip_h
	if sprite_body.flip_h == true:
		player_detection.scale.x = -1
		dash_circles_back_layer.scale.x = -1
		dash_circles_front_layer.scale.x = -1
		hit_detection.scale.x = -1
	else:
		player_detection.scale.x = 1
		dash_circles_back_layer.scale.x = 1
		dash_circles_front_layer.scale.x = 1
		hit_detection.scale.x = 1

func _on_punch_area_entered(area: Area2D) -> void:
	if area.is_in_group("delete_enemy_area"):
		self.queue_free()

func damage(boulder_x,enemy_x):
	sprite_body.get_material().set_shader_parameter("flash_enabled",true)
	$flash_timer.start()
	is_hit = true
	$CollisionShape2D.call_deferred("set_disabled",true)
	$hit_detection.call_deferred("set_monitorable", false)
	$charger_punch.call_deferred("set_monitorable",false)
	if boulder_x < enemy_x:
		hit_dir = 1
	else:
		hit_dir = -1
	delete(self.global_position)

func delete(pos):
	super(self.global_position)
	$death_audio.play()
	p0 = self.position
	p1 = Vector2(500 * hit_dir,-500) + self.position
	p2 = Vector2((700 * hit_dir) + self.position.x, 1000 + self.position.y)
	bezier(0)

func _on_flash_timer_timeout() -> void:
	sprite_body.get_material().set_shader_parameter("flash_enabled",false)


func _on_hit_detection_area_entered(area: Area2D) -> void:
	if area.name == "boulder_punch" or area.name == "player_boulder_punch":
		damage(area.global_position.x,self.global_position.x)


func _on_test_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		pass

func _on_pivot_area_entered(area: Area2D) -> void:
	if area.is_in_group("Pivot") and area.is_in_group("Wall_Pivot"):
		dir *= -1
		sprite_body.flip_h = !sprite_body.flip_h
		if sprite_body.flip_h == true:
			player_detection.scale.x = -1
			dash_circles_back_layer.scale.x = -1
			dash_circles_front_layer.scale.x = -1
			hit_detection.scale.x = -1
		else:
			player_detection.scale.x = 1
			dash_circles_back_layer.scale.x = 1
			dash_circles_front_layer.scale.x = 1
			hit_detection.scale.x = 1
