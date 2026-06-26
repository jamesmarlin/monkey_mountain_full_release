extends CharacterBody2D

signal death

var is_hit : bool
var hit_dir : int

@onready var p0
@onready var p1
@onready var p2
@onready var enemy_body = $Sprite2D


var time = 0

func bezier(t):
	var q0 = p0.lerp(p1,t)
	var q1 = p1.lerp(p2,t)
	var r = q0.lerp(q1,t)
	return r

func hit(dir):
	death.emit()
	enemy_body.get_material().set_shader_parameter("flash_enabled", true)
	$flash_timer.start()
	is_hit = true
	hit_dir = dir
	set_collision_layer_value(3,false)
	p0 = self.position
	p1 = Vector2(500 * hit_dir,-500) + self.position
	p2 = Vector2((700 * hit_dir) + self.position.x, 700 + DisplayServer.screen_get_size().y)

func _physics_process(delta: float) -> void:
	if is_hit:
		rotation += 0.05
		self.position = bezier(time)
		time += (delta * 0.8)
		if time >= 1:
			self.queue_free()

func _on_flash_timer_timeout() -> void:
	enemy_body.get_material().set_shader_parameter("flash_enabled", false)
