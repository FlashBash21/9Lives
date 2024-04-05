extends Area2D
class_name AreaDoor

@export var Area := 0
var enabled = false
var grace_period = 2


func _process(delta) -> void:
	if grace_period > 0:
		grace_period -= 1
		return
	var bodies = get_overlapping_bodies()
	if (bodies.size() == 0):
		enabled = true
		
	if (bodies.size() > 0 and enabled):
		var body = bodies[0] as Entity
		var parent = get_parent() as BaseArea
		if !parent:
			push_error("Door is not a child of a BaseArea node")
			return
		if (body):
			body.position = get_viewport().get_size() - Vector2i(body.position)
		parent.query_area_load.emit(Area)
