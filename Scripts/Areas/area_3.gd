extends BaseArea

var enemy_ref: Entity
var area_ref: BaseArea

func _ready() -> void:
	super()
	for i in range(3):
		var enemy = load_entity("melee_enemy")
		enemy.position = Vector2(get_viewport().get_size().x/4, get_viewport().get_size().y/4 * (i+1))
	area_ability = "dash"
