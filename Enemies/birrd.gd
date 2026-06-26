extends Enemy

@export var carried : bool
@export var collision_body : CollisionShape2D
@export var hit_detection : Area2D
@export var ground_detection : RayCast2D
@export_enum("pink", "blue") var birrd_color: String = "pink"

var carried_gravity = 0
var sprite_body

func _ready() -> void:
	sprite_body = $birrd_sprite
	if birrd_color == "pink":
		sprite_body.animation = "birrd_walk"
	if birrd_color == "blue":
		sprite_body.animation = "birrd_blue"
		sprite_body.frame = 0
	collision_body.call_deferred("set_disabled",true)
	if not carried:
		$drop_area.call_deferred("set_monitoring",false)
		$drop_area.call_deferred("set_monitorable",false)
		#sprite_body.play("birrd_walk")
	if dir == 1:
		sprite_body.flip_h = true
	elif dir == -1:
		sprite_body.flip_h = false

func _physics_process(delta: float) -> void:
	move_and_slide()
	if is_active:
		#checks for playing walk animations
		if ground_detection.is_colliding():
			if birrd_color == "pink":
				if sprite_body.animation == "birrd_glide":
					$AnimationPlayer.play("birrd_walk")
				else:
					sprite_body.play("birrd_walk")
			elif birrd_color == "blue":
				$AnimationPlayer.play("birrd_walk")
		else:
			if birrd_color == "pink":
				if $AnimationPlayer.current_animation == "birrd_walk":
					$AnimationPlayer.stop()
			#if $AnimationPlayer.current_animation != "birrd_walk":
				#sprite_body.stop()
				#sprite_body.animation = "birrd_hurt"
				#sprite_body.frame = 0
		if carried:
			velocity.y += 0 * delta
		else:
			velocity.y += gravity * delta
		#$AnimationPlayer.play("birrd_walk")
		velocity.x = move_speed * dir

func _process(delta: float) -> void:
	rotation_degrees = 0.0
	if is_hit:
		if birrd_color == "blue":
			sprite_body.frame = 1
		if birrd_color == "pink":
			if sprite_body.animation == "birrd_glide":
				sprite_body.frame = 1
			else:
				sprite_body.animation = "birrd_hurt"
				sprite_body.frame = 1
		rotation += 0.05
		self.position = bezier(time)
		time += (delta * 0.8)
		if time >= 1:
			self.queue_free()

func drop():
	#something here for animation
	#reparent node to enemies
	#change carried to false
	carried = false
	#switch to glide
	collision_body.call_deferred("set_disabled",false)
	if birrd_color == "pink":
		sprite_body.animation = "birrd_glide"
	else:
		sprite_body.animation = "birrd_blue_glide"
	sprite_body.frame = 0
	self.call_deferred("reparent",get_parent().get_parent())
	$drop_area.call_deferred("set_monitoring",false)
	$drop_area.call_deferred("set_monitorable",false)
	is_active = true

func delete(pos):
	$death_audio.play()
	$AnimationPlayer.stop()
	super(self.position)
	p0 = self.position
	p1 = Vector2(500 * hit_dir,-500) + self.position
	p2 = Vector2((700 * hit_dir) + self.position.x,1000 + self.position.y)
	bezier(0)

func damage(player_x,enemy_x):
	health -= 1
	sprite_body.get_material().set_shader_parameter("flash_enabled",true)
	$flash_timer.start()
	if health == 0:
		is_hit = true
		collision_body.call_deferred("set_disabled",true)
		hit_detection.call_deferred("set_monitorable", false)
		$pivot.call_deferred("set_monitorable",false)
		$bounce.call_deferred("set_monitorable",false)
		$bounce.call_deferred("set_monitoring",false)
		if player_x < enemy_x:
			hit_dir = 1
		else:
			hit_dir = -1
		delete(self.position)

func _on_hit_detection_area_entered(area: Area2D) -> void:
	if area.name == "charger_punch" or area.name == "player_punch" or area.name == "player_boulder_punch" or area.name == "boulder_punch":
		damage(area.global_position.x,self.global_position.x)
	if area.name == "delete_enemy_area":
		self.queue_free()

func _on_bounce_area_entered(area: Area2D) -> void:
	if area.name == "player_bounce":
		damage(area.global_position.x,self.global_position.x)

func _on_pivot_area_entered(area: Area2D) -> void:
	if area.is_in_group("Pivot"):
		dir *= -1
		if dir == 1:
			sprite_body.flip_h = true
		elif dir == -1:
			sprite_body.flip_h = false

func _on_pivot_body_entered(body: Node2D) -> void:
	dir *= -1
	if dir == 1:
		sprite_body.flip_h = true
	elif dir == -1:
		sprite_body.flip_h = false

func _on_flash_timer_timeout() -> void:
	#$CollisionShape2D.call_deferred("set_disabled",false)
	sprite_body.get_material().set_shader_parameter("flash_enabled",false)

func _on_drop_area_body_entered(body: Node2D) -> void:
	if body.name == "player" and carried:
		drop()

func _on_ground_detection_body_entered(body: Node2D) -> void:
	#if birrd_color == "pink":
		#if sprite_body.animation == "birrd_glide":
			#$AnimationPlayer.play("birrd_walk")
		#else:
			#sprite_body.play("birrd_walk")
	#else:
		#sprite_body.animation = "birrd_blue_glide"
		#$AnimationPlayer.play("birrd_walk")
	pass
	

func _on_ground_detection_body_exited(body: Node2D) -> void:
	if $AnimationPlayer.current_animation == "birrd_walk":
		$AnimationPlayer.stop()
	#REDO with another collision, if it's not touching anything, THEN
	 #you stop playing the animation
	if $AnimationPlayer.current_animation != "birrd_walk":
		sprite_body.stop()
		sprite_body.animation = "birrd_hurt"
		sprite_body.frame = 0

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if not is_active and not carried:
		collision_body.call_deferred("set_disabled",false)
		is_active = true

func _on_tree_exiting() -> void:
	#keep it at 0.0 for rotation_degrees
	if carried:
		drop()
