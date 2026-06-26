extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		var enemy = get_parent()
		if enemy.is_in_group("Enemy_Timer"):
			enemy.start()
		if enemy.is_in_group("Enemy"):
			enemy.is_active = true
			enemy.visible = true
