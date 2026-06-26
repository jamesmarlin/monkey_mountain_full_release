extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		var curr_scene_file = get_tree().current_scene.scene_file_path
		curr_scene_file[-6] = str(int(curr_scene_file[-6]) + 1)
		var next_stage = curr_scene_file
		#get_tree().call_deferred("change_scene_to_file",next_stage)
		GameManager.change_scene(next_stage)
		#for when player transition to a new level -> use for end of level door
		#get_tree().call_deferred("change_scene_to_file",level_path[curr_scene_file])
