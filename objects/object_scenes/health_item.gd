extends CharacterBody2D

func _ready() -> void:
	$Sprite2D.frame = randi_range(0,2)

func _on_health_item_area_entered(area: Area2D) -> void:
	if area.name == "item_pickup":
		self.queue_free()
