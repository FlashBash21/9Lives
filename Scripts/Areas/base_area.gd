extends Node2D
class_name BaseArea

signal query_area_load(area) #emit this to ask the area manager to switch areas

var enemy_type: Entity #TODO: make enemy class and have enemy_type be of type 'Enemy'
var adjacent_areas: PackedInt32Array #small array bc we wont need large

func ping():
	print("pong!")

func load_entity(entity: Entity) -> void:
	add_child(entity)

func clean_entites() -> void:
	for child in get_children():
		if child is Entity:
			remove_child(child)
