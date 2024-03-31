extends Node2D
class_name Ability

var local_cooldown := 0.
var level := 0

func execute(_args: Dictionary) -> void:
	push_error("Error: Execute not implemented")
	assert(false, "IMPLEMENT EXCECUTE")

func level_up() -> void:
	level += 1
