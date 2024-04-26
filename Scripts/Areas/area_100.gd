extends BaseArea


func _ready() -> void:
	var boss = load_entity("boss")
	boss.position = Vector2(300, 300)
