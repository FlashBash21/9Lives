extends Projectile

var basic_projectile_object = load("res://Scenes/Objects/basic_projectile_object.tscn")
#var self_position: Vector2
#var aim_direction

var velocity: Vector2


func execute(args: Dictionary) -> void:
	print("BANG")
	var entity = args["entity"] as Entity
	var speed = args["speed"] as float
	var direction = args["direction"] as Vector2
	local_cooldown = args["cooldown"] as float
	var damage = args["damage"] as int
	
	
	
	if last_shot < local_cooldown: return 		#ability still on cooldown
	else: last_shot = 0
	
	var projectile = basic_projectile_object.instantiate()
	projectile.add_collision_exception_with(entity)

	var area = get_tree().get_first_node_in_group("Area")
	if (!area): 
		area = get_node("/root")
	area.add_child(projectile)
	
	projectile.look_at(get_local_mouse_position())
	projectile.position = get_parent().position
	velocity = Vector2(1, 0).rotated(projectile.rotation) * speed
	
	projectiles.append({
		"projectile": projectile,
		"velocity": velocity,
		"ticks": 0
		})
