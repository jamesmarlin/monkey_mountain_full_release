extends StaticBody2D

var time = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += 1
	$AnimatedSprite2D.position += Vector2(0, sin(time) * 2)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player' or body.is_in_group("Enemy"):
		set_process(true)
		$Timer.start(.5)

func _on_timer_timeout():
	$Timer.stop()
	if is_processing():
		#breaks
		set_process(false)
		$AnimatedSprite2D.play("default")
		$CollisionShape2D.set_deferred("disabled",true)
		await $AnimatedSprite2D.animation_finished
		$Area2D.set_deferred("monitoring", false)
		$Timer.start(.1)
	else:
		#resets
		$AnimatedSprite2D.play_backwards("default")
		await $AnimatedSprite2D.animation_finished
		$Area2D.set_deferred("monitoring", true)
		$CollisionShape2D.set_deferred("disabled",false)
