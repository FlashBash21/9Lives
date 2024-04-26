extends BaseArea


func _ready() -> void:
	super()
	var enemy = load_entity("test_enemy")
	enemy.position = Vector2(200, 200)
