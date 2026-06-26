extends Line2D

@export var path_node: Path2D

func _ready() -> void:
	if path_node:
		var curve = path_node.curve
		var baked_points = curve.get_baked_points()
		points = baked_points
