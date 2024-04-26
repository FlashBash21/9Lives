extends BaseArea

var enemy_ref: Entity
var area_ref: BaseArea

func _ready() -> void:
	super()
	for i in range(2):
		var enemy = load_entity("tri_ranged_enemy")
		enemy.position = Vector2(get_viewport().get_size().x/2, get_viewport().get_size().y/2 * (i+1))
	area_ability = "TriRanged"
