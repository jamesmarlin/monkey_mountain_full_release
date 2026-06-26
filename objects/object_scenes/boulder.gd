extends RigidBody2D

@export
var is_active : bool

var on_ground : bool

var push_speed : int = 500

#func _ready() -> void:
	#gravity_scale = 1.0

#func _physics_process(delta: float) -> void:
	#if is_active:
		##print(linear_velocity)
		#gravity_scale = 2.0

func push(player_loc_x,boulder_loc_x):
	var force = Vector2.ZERO
	var force_dir = 0
	if player_loc_x < boulder_loc_x:
		force_dir = 1
	else:
		force_dir = -1
	force.x = force_dir * push_speed
	apply_force(force)

func _on_floor_detection_body_entered(body: Node2D) -> void:
	if body.name != "boulder":
		on_ground = true

func _on_hit_detection_area_entered(area: Area2D) -> void:
	if area.name == "player_punch":
		push(area.global_position.x,self.global_position.x)
	if area.is_in_group("delete_enemy_area"):
		self.queue_free()
