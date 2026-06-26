extends Area2D

@export var next_level : String

@export var rotation_speed := 4.0
@export var animation_player : AnimationPlayer

var level_path = {"A" : "res://game_levels/level-A/level-A-1.tscn",
"B" : "res://game_levels/level-B/level-B-1.tscn",
"C" : "res://game_levels/level-C/level-C-1.tscn",
"D" : "res://game_levels/level-D/level-D-1.tscn",
"E" : "res://game_levels/level-E/level-E-1.tscn",
"F" : "res://game_levels/level-F/level-F-1.tscn",
"G" : "res://game_levels/level-G/level-G-End.tscn"}

func _on_body_entered(body: Node2D) -> void:
	#confirm if player has entered, refer to export var
	#and key value pair for correct
	#level transition
	if body.name == "player":
		GameManager.pause_during_transfer()
		BackgroundMusic.fade_music_out_background()
		$end_of_level.play()
		animation_player.play("grow_and_fade")
		await animation_player.animation_finished
		GameManager.level_complete(level_path[next_level])
		
func _physics_process(delta: float) -> void:
	$Sprite2D.rotation += rotation_speed * delta
	
func end_of_stage():
	var tween = create_tween()
	
	tween.tween_property(self, "scale", Vector2(2.0, 2.0), 0.5)

	# 1. Shrink slightly (e.g., to half the size in 0.2 seconds)
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.2)
	
	# 3. Fade out (Alpha goes to 0 over 0.5 seconds)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	
	return
