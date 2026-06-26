extends Node2D

const FILE_BEGIN = "res://levels/level_"

@export var has_lock : bool

func _ready():
	if has_lock:
		$AnimatedSprite2D.set_deferred("visible",true)

func _physics_process(delta):
	$Sprite2D.rotation += 1 * delta;

func _on_area_2d_body_entered(body):
	if body.name == "player" and body.can_enter:
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		if next_level_number == 14:
			get_tree().call_deferred("change_scene_to_file","res://end_menu.tscn")
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		#get_tree().change_scene_to_file(next_level_path)
		get_tree().call_deferred("change_scene_to_file",next_level_path)
