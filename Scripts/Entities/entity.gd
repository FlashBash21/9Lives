extends CharacterBody2D
class_name Entity


var hp: int
var energy: int
var speed: float
var max_speed: float
var acceleration: float

var global_cooldown: int
var last_ability: int
var abilities_list: Array


func _process(delta:float) -> void:
	last_ability += 1
func regen_health() -> void:
	pass
func regen_energy() -> void:
	pass
func modify_energy(amount: int) -> void:
	pass
func modify_life(amount: int) -> void:
	pass
func apply_damage(ammount: int) -> void:
	pass
	
#IMPORTANT
#for abilities to load properly, their parent entities should be instantiated via code
#adding parent entities to the scene via the editor may cause unintended errors
#this code has been designed with this limitation in mind. all entities should be able to
#be easily instantiated into an area via helper functions. doing this yourself should
#not be hard
#IMPORTANT
func load_ability(name:String) -> Ability:
	var ability = load("res://Scenes/Abilities/%s_ability.tscn" % name)
	var abilityNode = ability.instantiate() as Ability
	if(!abilityNode):
		push_error("Error loading scene for ability: \"%s\"! Ability is null. 
					Check your scene exists with the proper name" % name)
		return null
	add_child(abilityNode)
	return abilityNode
