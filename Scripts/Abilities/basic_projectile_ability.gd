extends Projectile

var basic_projectile_object = load("res://Scenes/Objects/basic_projectile_object.tscn")
#var self_position: Vector2
#var aim_direction

var velocity: Vector2


func execute(args: Dictionary) -> void:
	var entity = args["entity"] as Entity
	var speed = args["speed"] as float
	var direction = args["direction"] as Vector2
	local_cooldown = args["cooldown"] as float
	var damage = args["damage"] as int
	var effectors = args["effectors"] as Array[StringName]
	
	damage += (level-1)
	speed = speed + (speed * .1 * level)
	
	effector_groups = effectors
	add_effector_group(effector_groups[0])
	
	if last_shot < local_cooldown || level < 1: return 		#ability still on cooldown OR hasn't been aquired
	else: last_shot = 0
	
	var projectile = basic_projectile_object.instantiate()
	projectile.add_collision_exception_with(entity)

	var area = get_tree().get_first_node_in_group("Area")
	if (!area): 
		area = get_node("/root")
	area.add_child(projectile)
	
	projectile.look_at(direction)
	projectile.position = get_parent().position
	velocity = Vector2(1, 0).rotated(projectile.rotation) * speed
	
	$AudioStreamPlayer.play()
	
	projectiles.append({
		"projectile": projectile,
		"velocity": velocity,
		"time": 0,
		"damage": damage
		})
