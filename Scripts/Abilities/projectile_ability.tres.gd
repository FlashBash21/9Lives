extends Ability
class_name Projectile

var projectiles = []
var entity: Entity
var cooldown: float
var speed: float
var direction: Vector2
var damage: int


var last_shot = 0

func execute(args: Dictionary) -> void:
	var entity = args["entity"] as Entity
	var speed = args["speed"] as float
	var direction = args["direction"] as Vector2
	var cooldown = args["cooldown"] as float
	var damage = args["damage"] as int
	
	
	
func fire(_args: Dictionary) -> void:
	push_error("Error: Fire not implemented")
	assert(false, "IMPLEMENT FIRE")
	

	
func _physics_process(delta):
	last_shot += 1
	for i in projectiles:
		var p = i["projectile"]
		var vel = i["velocity"]
		
		if i["ticks"] >= 100:
			p.queue_free()
			projectiles.erase(i)
			pass
		
		var collision = p.move_and_collide(vel * delta)
		
		if collision:
			var collider = collision.get_collider()
			if(collider.get_class() == "Entity"):
				collider.apply_damage(damage)
				print("ow")
			p.queue_free()
			projectiles.erase(i)
		i["ticks"] += 1
