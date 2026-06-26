extends Enemy

signal birrd_fly_death
signal birrd_fly_movement_cancel


@onready var sprite_body = $Sprite2D
@onready var birrd_path = get_parent()
@export var collision_body : CollisionShape2D
@export var hit_detection : Area2D

func _process(delta: float) -> void:
	if is_hit:
		sprite_body.frame = 1
		rotation += 0.05
		birrd_path.rotation_degrees = 0.0
		birrd_fly_movement_cancel.emit()
		self.position = bezier(time)
		time += (delta * 0.8)
		if time >= 1:
			birrd_fly_death.emit()
			self.queue_free()

func _on_hit_detection_area_entered(area: Area2D) -> void:
	if area.name == "charger_punch" or area.name == "player_punch" or area.name == "player_boulder_punch":
		damage(area.global_position.x,self.global_position.x)
	if area.name == "delete_enemy_area":
		self.queue_free()

func _on_bounce_area_entered(area: Area2D) -> void:
	if area.name == "player_bounce":
		damage(area.global_position.x,self.global_position.x)

func delete(pos):
	#super(self.global_position)
	$death_audio.play()
	p0 = self.position
	p1 = Vector2(500 * hit_dir,-500) + self.position
	p2 = Vector2((700 * hit_dir) + self.position.x, 1000 + self.position.y)
	bezier(0)

func damage(player_x,enemy_x):
	health -= 1
	sprite_body.get_material().set_shader_parameter("flash_enabled",true)
	$flash_timer.start()
	if health == 0:
		is_hit = true
		collision_body.call_deferred("set_disabled",true)
		hit_detection.call_deferred("set_monitorable", false)
		$bounce.call_deferred("set_monitorable",false)
		$bounce.call_deferred("set_monitoring",false)
		if player_x < enemy_x:
			hit_dir = 1
		else:
			hit_dir = -1
		delete(self.global_position)

func _on_flash_timer_timeout() -> void:
	sprite_body.get_material().set_shader_parameter("flash_enabled",false)
