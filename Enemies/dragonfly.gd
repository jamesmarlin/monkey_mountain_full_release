extends Enemy
var sprite_body

## How far enemy moves on y axis
@export
var amplitude : float =  50.0
## How fast enemy moves on y axis
@export
var frequency : float = 5.0
var move_time : float = 0.0
@export var hit_detection : Area2D

var y_offset = cos(move_time * frequency) * amplitude
func _ready() -> void:
	sprite_body = $Sprite2D
	if dir == 1:
		sprite_body.flip_h = true
	else:
		sprite_body.flip_h = false
	sprite_body.play("move")
	sprite_body.set_speed_scale(y_offset/(y_offset * 2))

func _physics_process(delta: float) -> void:
	move_time += delta
	y_offset = cos(move_time * frequency) * amplitude
	if is_active:
		velocity.x = move_speed * dir
		velocity.y = y_offset
	move_and_slide()

func _process(delta: float) -> void:
	if is_hit:
		rotation += 0.05
		self.position = bezier(time)
		time += (delta * 0.8)
		if time >= 1:
			self.queue_free()

func delete(pos):
	$death_audio.play()
	sprite_body.play("death")
	super(self.position)
	
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
		hit_detection.call_deferred("set_monitorable", false)
		$CollisionShape2D.call_deferred("set_disabled",true)
		$bounce.call_deferred("set_monitorable",false)
		if player_x < enemy_x:
			hit_dir = 1
		else:
			hit_dir = -1
		delete(self.global_position)

func _on_hit_detection_area_entered(area: Area2D) -> void:
	if area.name == "charger_punch" or area.name == "player_punch" or area.name == "player_boulder_punch":
		damage(area.global_position.x,self.global_position.x)
	if area.name == "delete_enemy_area":
		self.queue_free()

func _on_flash_timer_timeout() -> void:
	sprite_body.get_material().set_shader_parameter("flash_enabled",false)

func _on_bounce_area_entered(area: Area2D) -> void:
	if area.name == "player_bounce":
		damage(area.global_position.x,self.global_position.x)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if not is_active:
		is_active = true
