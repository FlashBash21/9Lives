extends BaseArea


func _ready() -> void:
	super()
	var boss = load_entity("boss")
	boss.position = Vector2(580, 300)
	area_ability = "Health"
