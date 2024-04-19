extends BaseArea


func _ready() -> void:
	super()
	var boss = load_entity("boss_enemy")
	var enemy = load_entity("test_enemy")
	#var enemy2 = load_entity("test_enemy")
	enemy.position = Vector2(200, 200)
	boss.position = Vector2(300, 300)
