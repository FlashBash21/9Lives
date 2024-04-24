extends Projectile

var basic_projectile_object = load("res://Scenes/Objects/basic_projectile_object.tscn")


var velocity: Vector2


func execute(args: Dictionary) -> void:
	var entity = args["entity"] as Entity
	var speed = args["speed"] as float
	var direction = args["direction"] as Vector2
	local_cooldown = args["cooldown"] as float
	var damage = args["damage"] as int
	var effectors = args["effectors"] as Array[StringName]
	
	effector_groups = effectors
	add_effector_group(effector_groups[0])
	
	
	if last_shot < local_cooldown: return 		#ability still on cooldown
	else: last_shot = 0
	
	#directions for each bullet
	var middle_direction = direction
	var left_direction = direction.rotated(deg_to_rad(-15))
	var right_direction = direction.rotated(deg_to_rad(15))
	
	#obj for each bullet
	var middle_projectile = basic_projectile_object.instantiate()
	middle_projectile.add_collision_exception_with(entity)
	
	
	var left_projectile = basic_projectile_object.instantiate()
	left_projectile.add_collision_exception_with(entity)
	
	
	var right_projectile = basic_projectile_object.instantiate()
	right_projectile.add_collision_exception_with(entity)
	
	var area = get_tree().get_first_node_in_group("Area")
	if (!area): 
		area = get_node("/root")
		
	area.add_child(middle_projectile)
	area.add_child(left_projectile)
	area.add_child(right_projectile)
	
	middle_projectile.look_at(middle_direction)
	middle_projectile.position = get_parent().position
	var middle_velocity = Vector2(1, 0).rotated(middle_projectile.rotation) * speed
	
	left_projectile.look_at(left_direction)
	left_projectile.position = get_parent().position
	var left_velocity = Vector2(1, 0).rotated(left_projectile.rotation) * speed
	
	right_projectile.look_at(right_direction)
	right_projectile.position = get_parent().position
	var right_velocity = Vector2(1, 0).rotated(right_projectile.rotation) * speed
	
	projectiles.append({
		"projectile": middle_projectile,
		"velocity": middle_velocity,
		"ticks": 0,
		"damage": damage,
		"time": 0
		})
		
	projectiles.append({
		"projectile": left_projectile,
		"velocity": left_velocity,
		"ticks": 0,
		"damage": damage,
		"time": 0
		})
		
	projectiles.append({
		"projectile": right_projectile,
		"velocity": right_velocity,
		"ticks": 0,
		"damage": damage,
		"time": 0
		})
