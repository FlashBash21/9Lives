extends BaseArea

var enemy = preload("res://Scenes/Entites/test_enemy.tscn")

var enemy_ref: Entity
var area_ref: BaseArea

func _ready() -> void:
	super()
	enemy_ref = enemy.instantiate()
	var e1 = load_entity("test_enemy")
	e1.position = Vector2(200, 200 )
	area_ability = "Move"
