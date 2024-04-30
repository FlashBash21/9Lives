extends Ability


func execute(args: Dictionary):
	var entity = args["entity"] as Entity
	var speed = args["speed"] as int
	var direction = args["direction"] as Vector2
	
	speed += level * (speed * .15) 
	
	var vel = direction * speed
	entity.velocity = vel
	#entity.rotation = Vector2.UP.angle_to(entity.velocity.normalized())
	entity.move_and_slide()
	
