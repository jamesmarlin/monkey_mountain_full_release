extends AudioStreamPlayer

func fade_music_out_main_death(duration: float = 1.5):
	var tween = create_tween()
	# Interpolate from current volume down to -80 dB (silence)
	tween.tween_property(self, "volume_db", -80.0, duration)
	# Automatically stop the player when the tween finishes
	tween.tween_callback(self.stop)
	#Main_DeathScreenMusic.stop()

func restart_music():
	self.volume_db = 0.0
	Main_DeathScreenMusic.play()
