extends Ability

func execute(args: Dictionary):
	var entity = args["entity"] as Entity
	var speed = args["speed"] as int
	var direction = args["direction"] as Vector2
	
	var vel = direction * speed
	entity.velocity = vel
	entity.move_and_slide()
