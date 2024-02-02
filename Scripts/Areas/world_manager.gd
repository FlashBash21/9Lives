extends Node2D

var current_area = 0
var area_ref: BaseArea
var player_ref: Entity #constantly hold onto a player reference. we can insert and remove this from child scenes while retaining player information

func _ready() -> void:
	var player = load("res://Scenes/Entites/player.tscn")
	player_ref = player.instantiate()
	load_area(0)
	area_ref.ping()

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_accept")):
		load_area(1)
	if (Input.is_action_just_pressed("ui_cancel")):
		area_ref.ping()

#automatically unloads current area and connects to its area query signal
func load_area(area_num: int) -> void:
	#load area and add it as a child
	if (area_ref):
		area_ref.clean_entites()
		remove_child(area_ref)
	var next = load("res://Scenes/Areas/area_%d.tscn" % area_num) #string formatting!
	area_ref = next.instantiate()
	add_child(area_ref)
	area_ref.load_entity(player_ref)
	#reconnect the signal
	area_ref.connect("query_area_load", load_area)
