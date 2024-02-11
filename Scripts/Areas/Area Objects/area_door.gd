extends Area2D
class_name AreaDoor

@export var Area: int

func _process(delta) -> void:
	var bodies = get_overlapping_bodies()
	if (bodies.size() > 0):
		var body = bodies[0] as Entity
		var parent = get_parent() as BaseArea
		if !parent:
			push_error("Door is not a child of a BaseArea node")
			return
		if !Area:
			push_error("No Area defined for door")
			return
		if (body):
			body.position = get_viewport().get_size() - Vector2i(body.position)
		parent.query_area_load.emit(Area)
