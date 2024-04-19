extends Ability

func execute(args: Dictionary) -> void:
	var entity = args["entity"] as Entity
	var maxHealth = args["max"] as float
	$Fill.scale.x = entity.hp / maxHealth
