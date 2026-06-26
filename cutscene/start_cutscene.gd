extends AnimatedSprite2D

func _ready():
	self.play()
	BackgroundMusic.play(0.0)
	await self.animation_finished
	get_tree().change_scene_to_file("res://levels/level_1.tscn")
