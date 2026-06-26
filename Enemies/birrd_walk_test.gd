extends Enemy

func _ready() -> void:
	$AnimatedSprite2D.play("walk")

func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity.y += gravity * delta
	velocity.x = move_speed * dir
