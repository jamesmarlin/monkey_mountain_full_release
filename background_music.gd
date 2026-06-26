extends AudioStreamPlayer

func fade_music_out_background(duration: float = 1.5):
	var tween = create_tween()
	# Interpolate from current volume down to -80 dB (silence)
	tween.tween_property(self, "volume_db", -80.0, duration)
	tween.tween_callback(self.stop)

func restart_music():
	self.volume_db = 0.0
	BackgroundMusic.play()
