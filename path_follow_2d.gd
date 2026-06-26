extends PathFollow2D

var speed = 0

var state_frame = {"move" : 0,"jump_up" : 2, "jump_land" : 3}

func choose_frame(state_name):
	#unhide
	self.visible = true
	$particles.frame = state_frame[state_name]
	speed = 4.0

func _process(delta: float) -> void:
	#while moving do not switch the horizontal!!!
	progress_ratio += delta * speed
	#when path is over:
		#hide
		#set speed to 0
		#start back at the beginning
	if progress_ratio == 1.0:
		self.visible = false
		speed = 0
		progress = 0.0
