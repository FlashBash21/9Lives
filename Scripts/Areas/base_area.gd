extends Node2D
class_name BaseArea

signal query_area_load(area) #emit this to ask the area manager to switch areas

var enemy_type: Entity #TODO: make enemy class and have enemy_type be of type 'Enemy'
var area_ability: StringName

func _ready() -> void:
	add_to_group("Area")

#adds an already loaded entity to the area
func add_entity(entity: Entity) -> void:
	add_child(entity)

#loads an unloaded entity and adds it to the area
func load_entity(entity: StringName) -> Entity:
	var loaded_entity = load("res://Scenes/Entites/" + entity + ".tscn")
	if (!loaded_entity):
		push_error("Invalid Path: res://Scenes/Entites/" + entity + ".tscn")
		return null
	var ref = loaded_entity.instantiate()
	add_child(ref)
	return ref

func load_projectile(proj: Projectile) -> void:
	add_child(proj)

func clean_entites() -> void:
	for child in get_children():
		if child is Entity:
			remove_child(child)
