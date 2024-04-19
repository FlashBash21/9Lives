extends BaseArea


func _ready() -> void:
	var enemy = load("res://Scenes/Entites/test_enemy.tscn")
	var enemy_ref = enemy.instantiate() 
	add_child(enemy_ref)
	enemy_ref.position = Vector2(200, 200)
	super()
	var boss = load_entity("boss_enemy")
	var enemy = load_entity("test_enemy")
	#var enemy2 = load_entity("test_enemy")
	enemy.position = Vector2(200, 200)
	boss.position = Vector2(300, 300)
