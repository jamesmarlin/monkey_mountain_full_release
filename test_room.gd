extends Node2D

var enemy
var enemy_node

func _ready() -> void:
	#BackgroundMusic.play()
	#for child in $Enemies.get_children():
		#child.death.connect(on_camera_shake)
	$player.camera_shake.connect(on_camera_shake)

func on_camera_shake():
	$player_camera.apply_shake()
