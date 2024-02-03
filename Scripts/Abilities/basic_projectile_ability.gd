extends Projectile

var basic_projectile_object = load("res://Scenes/Objects/basic_projectile_object.tscn")
#var self_position: Vector2
#var aim_direction

var velocity: Vector2


func fire(args: Dictionary) -> void:
	print("BANG")
	var entity = args["entity"] as Entity
	var speed = args["speed"] as float
	var direction = args["direction"] as Vector2
	var cooldown = args["cooldown"] as float
	var damage = args["damage"] as int
	
	
	
	if last_shot < cooldown: return 		#ability still on cooldown
	else: last_shot = 0
	
	var projectile = basic_projectile_object.instantiate()
	#projectile.add_collision_exception_with(entity)
	get_node("/root").add_child(projectile)

	
	projectile.look_at(get_local_mouse_position())
	projectile.position = entity.position
	print(projectile.position)
	velocity = Vector2(speed, 0).rotated(projectile.rotation)
	
	projectiles.append({
		"projectile": projectile,
		"velocity": velocity,
		"ticks": 0
		})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
