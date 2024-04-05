extends BaseArea


func _ready() -> void:
	var enemy = load("res://Scenes/Entites/test_enemy.tscn")
	var enemy_ref = enemy.instantiate() 
	add_child(enemy_ref)
	enemy_ref.position = Vector2(100, 100)
	super()
