class_name Enemy
extends CharacterBody2D

signal death
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var health_item = preload("res://objects/object_scenes/health_item.tscn")
var enemy_death_audio = preload("res://Enemies/Retro Blop 22.wav")

@export
var is_active : bool
@export
var dir : int
@export
var is_hit : bool = false
@export
var hit_dir : int

@export
var health : int
@export
var move_speed : int

@onready var p0 : Vector2 = self.position
@onready var p1 : Vector2
@onready var p2 : Vector2

@onready var time : float = 0.0

func delete(pos) -> void:
	#why is position not working anymore?
	if randf() < 0.40:
		var health_item_inst = health_item.instantiate()
		#self.call_deferred("reparent",get_parent().get_parent())
		await get_tree().create_timer(0.5).timeout
		get_parent().add_child.call_deferred(health_item_inst)
		health_item_inst.global_position = pos
	death.emit()

func bezier(t) -> Vector2:
	var q0 = p0.lerp(p1,t)
	var q1 = p1.lerp(p2,t)
	var r = q0.lerp(q1,t)
	return r
