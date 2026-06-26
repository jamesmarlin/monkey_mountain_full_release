extends Node2D

@export var animation : AnimationPlayer
@export var animation_foreward : bool
@export var coins : AnimatedSprite2D
@export var player_detection : Area2D

@export var move_speed : int = 600
var player : Node2D

func _ready() -> void:
	#choose rand coin img
	set_physics_process(false)
	coins.frame = randi_range(0,coins.sprite_frames.get_frame_count("coins"))
	if animation_foreward:
		animation.play("spin")
	else:
		animation.play_backwards("spin")

func _on_coin_item_area_entered(area: Area2D) -> void:
	if area.name == "item_pickup":
		self.queue_free()

func _on_player_detection_body_entered(body: Node2D) -> void:
	#float to player
	#if body.is_in_group("Player"):
		#player = body
		#set_physics_process(true)
	pass


func _physics_process(delta: float) -> void:
	#keep updating collision
	#if player_detection.has_overlapping_bodies():
		#player_position = player_detection.get_overlapping_bodies()[0].global_position
	self.global_position = self.global_position.move_toward(player.global_position,move_speed * delta)
