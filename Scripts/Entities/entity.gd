extends CharacterBody2D
class_name Entity

var hp: int
var energy: int
var speed: float
var max_speed: float
var acceleration: float
var global_cooldown: float

func regen_health() -> void:
	pass
func regen_energy() -> void:
	pass
func modify_energy(amount: int) -> void:
	pass
func modify_life(amount: int) -> void:
	pass
func load_ability(): #-> Ability
	pass
