extends Area2D

@export_category("Enemies")
@export var birrd_enemy : bool
@export var dragonfly_enemy : bool
@export var charger_enemy : bool
@export var boulder : bool

@export var is_active : bool
@export var dir : int
@export var move_speed : int
@export var gravity_scale : float

@export var spawn_timer : int = 1

@onready var birrd_instance = preload("res://Enemies/birrd.tscn")
@onready var dragonfly_instance = preload("res://Enemies/dragonfly.tscn")
@onready var charger_instance = preload("res://Enemies/charger.tscn")
@onready var boulder_instance = preload("res://objects/object_scenes/boulder.tscn")

var curr_inst

func _ready() -> void:
	#spawn the first enemy 
	$spawner_timer.wait_time = spawn_timer

func spawn():
	if birrd_enemy:
		curr_inst = birrd_instance.instantiate()
	if dragonfly_enemy:
		curr_inst = dragonfly_instance.instantiate()
	if charger_enemy:
		curr_inst = charger_instance.instantiate()
	if boulder:
		curr_inst = boulder_instance.instantiate()
		curr_inst.is_active = is_active
		curr_inst.gravity_scale = gravity_scale
		curr_inst.global_position = $Marker2D.global_position
		get_parent().add_child.call_deferred(curr_inst)
	else:
		curr_inst.is_active = is_active
		curr_inst.dir = dir
		curr_inst.move_speed = move_speed
		curr_inst.global_position = $Marker2D.global_position
		get_parent().add_child.call_deferred(curr_inst)

func _on_spawner_timer_timeout() -> void:
	spawn()

func start() -> void:
	$spawner_timer.start()
	if birrd_enemy:
		curr_inst = birrd_instance.instantiate()
	if dragonfly_enemy:
		curr_inst = dragonfly_instance.instantiate()
	if charger_enemy:
		curr_inst = charger_instance.instantiate()
	if boulder:
		curr_inst = boulder_instance.instantiate()
		curr_inst.is_active = is_active
		curr_inst.gravity_scale = gravity_scale
		curr_inst.global_position = $Marker2D.global_position
		get_parent().add_child.call_deferred(curr_inst)
	else:
		curr_inst.is_active = is_active
		curr_inst.dir = dir
		curr_inst.move_speed = move_speed
		curr_inst.global_position = $Marker2D.global_position
		get_parent().add_child.call_deferred(curr_inst)
