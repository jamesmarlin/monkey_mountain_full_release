extends CharacterBody2D

var player : Node2D
var canMove : bool = false

@onready
var maxRange : int = 90
@onready
var swingspeed : int = 20

func _physics_process(delta: float) -> void:
	if (rotation_degrees < maxRange) or (rotation_degrees > -maxRange):
		if canMove:
			var movement = Input.get_axis('ui_left','ui_right') * swingspeed
			rotation_degrees += movement
		else:
			rotation_degrees = 0


func _on_child_entered_tree(node: Node) -> void:
	if node.name == "player":
		canMove = true

func _on_child_exiting_tree(node: Node) -> void:
	if node.name == "player":
		canMove = false
