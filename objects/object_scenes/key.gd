extends Node2D

var time = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += .04
	$Sprite2D.position += Vector2(0, sin(time) * 1)
	

func _on_area_2d_body_entered(body):
	if body.name == "player":
		self.set_deferred("visible",false)
		$Area2D.set_deferred("monitoring",false)
		body.can_enter = true
