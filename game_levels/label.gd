extends Label

var can_fade : bool = true

func _ready():
	# Start fully transparent
	modulate.a = 0.0
	fade_in_and_out()

func fade_in_and_out():
	# Create a looping effect
	while can_fade:
		var tween = create_tween()
		
		tween.tween_property(self, "modulate:a", 1.0, 1.0)
		await tween.finished

		await get_tree().create_timer(0.1).timeout
		
		tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 1.0)
		await tween.finished
		
		await get_tree().create_timer(0.1).timeout
