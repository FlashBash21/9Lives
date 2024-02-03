extends Area2D
class_name AreaDoor

@export var Area: int

func _process(delta) -> void:
	if (get_overlapping_bodies().size() > 0):
		var parent = get_parent() as BaseArea
		if !parent:
			push_error("Door is not a child of a BaseArea node")
			return
		if !Area:
			push_error("No Area defined for door")
			return
		parent.query_area_load.emit(Area)
