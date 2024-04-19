extends BaseArea

var enemy_ref: Entity
var area_ref: BaseArea

func _ready() -> void:
	var enemy = load("res://Scenes/Entites/boss.tscn")
	enemy_ref = enemy.instantiate() 
	add_child(enemy_ref)
	enemy_ref.position = Vector2(580, 300)
	super()
