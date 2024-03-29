extends BaseArea

var enemy_ref : Entity
var area_ref: BaseArea

func _ready() -> void:
	var enemy = load("res://Scenes/Entites/test_enemy.tscn")
	enemy_ref = enemy.instantiate() 
	add_child(enemy_ref)
	enemy_ref.position.x = 100
	enemy_ref.position.y = 100
	super()
