extends RigidBody2D

const swingspeed : int = 300
const maxspeed : int = 500

@onready
var canMove : bool = false

func _physics_process(delta: float) -> void:
	var force = Vector2.ZERO
	if canMove:
		var movement = Input.get_axis('ui_left','ui_right')
		if movement:
			force.x = movement * swingspeed
			if abs(linear_velocity.x) > maxspeed: linear_velocity.x = maxspeed * movement
		apply_central_force(force)

func _on_child_entered_tree(node: Node) -> void:
	if node.name == "player":
		canMove = true

func _on_child_exiting_tree(node: Node) -> void:
	if node.name == "player":
		canMove = false

func get_rope_position(body):
	var new_position
	var shortest_distance
	
	for child in get_children():
		if not child is Marker2D: continue
		
		var distance = body.global_position.distance_to(child.global_position)
		
		if not shortest_distance || distance < shortest_distance:
			new_position = child.global_position
			shortest_distance = distance
			
	return new_position
