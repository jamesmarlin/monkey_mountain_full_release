extends Node2D

func _ready() -> void:
	Main_DeathScreenMusic.play(0.0)
	GameManager.main_menu()
	GameManager.set_ui_visibility()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("punch_action"):
		Main_DeathScreenMusic.fade_music_out_main_death()
		#Main_DeathScreenMusic.stop()
		$start_sound.play()
		await flash()
		await $start_sound.finished
		#GameManager.exit_main_menu()
		#transition
		GameManager.curr_level = "A"
		GameManager.level_transition("res://game_levels/level-A/level-A-1.tscn")
		GameManager.exit_main_menu()
		#get_tree().change_scene_to_file("res://game_levels/level-A/level-A-1.tscn")

func flash():
	$Label.can_fade = false
	#$text_flash.start()
	#await get_tree().create_timer(0.4).timeout
	#$text_flash.stop()
	for i in range(3):
		$Label.hide()
		await get_tree().create_timer(0.1).timeout
		$Label.show()
		await get_tree().create_timer(0.1).timeout
	$Label.show()

func _on_text_flash_timeout() -> void:
	$Label.visible = !$Label.visible 
