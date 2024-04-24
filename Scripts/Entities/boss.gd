extends Entity

var basic_projectile_object = load("res://Scenes/Objects/basic_projectile_object.tscn")

var health_bar : Ability

var screenWidth = 1152
var screenHeight = 648

var focused_entity : Entity
var recent_hits := []
var tracking: float = 90 * PI / 180

var projectiles := []

var noAction = true
var actionCount = 0
var zoneCount = 5

func _ready():
	self.hp = 200
	add_to_group("Enemy")
	
	health_bar = load_ability("Boss/healthBar")
	var freeNode = Node.new()
	add_child(freeNode)
	health_bar.reparent(freeNode)
	health_bar.global_position = Vector2(screenWidth/2., screenHeight - 50)
	
	focused_entity = null
	speed = 0

func _process(delta: float) -> void:
	if (noAction): nextAction()
	hit_RHand()
	hit_LHand()

func _physics_process(delta: float) -> void:
	for bullet in projectiles:
		var p = bullet["projectile"] as CharacterBody2D
		var vel = bullet["velocity"]
		
		if bullet["time"] >= 10:
			p.queue_free()
			projectiles.erase(bullet)
			pass
		
		var collision = p.move_and_collide(vel * delta)
		if collision:
			var collider = collision.get_collider() as Entity
			if collider.is_in_group("Player"):
					collider.apply_damage(1)
					print("projectile hit")
					p.queue_free()
					projectiles.erase(bullet)
			p.add_collision_exception_with(collider)
		bullet["time"] += delta
	
	if (!focused_entity): return
	
	if (tracking > 0):
		var maxA = tracking * delta
		var da = get_angle_to(focused_entity.position)
		if (maxA > abs(da)):
			look_at(focused_entity.position)
		else:
			rotate(maxA * sign(da))
	
	if (speed > 0):
		velocity = Vector2(1,0).rotated(rotation) * speed
		move_and_slide()

func nextAction() -> void:
	find_enemies_to_focus()
	noAction = !focused_entity
	if (noAction): return
	
	var distance = position.distance_to(focused_entity.position)
	
	if (hp < 100):
		if (zoneCount >= 5):
			$AnimationPlayer.queue("Zone_1")
			zoneCount = 0
			return
		else:
			zoneCount += 1
	
	if (actionCount >= 2):
		$AnimationPlayer.queue("Lunge")
		actionCount = 0
	elif distance < 300:
		$AnimationPlayer.queue("Punch")
		actionCount += 1
	else:
		$AnimationPlayer.queue("Slam")
		actionCount += 2

func setTracking(value: float) -> void:
	tracking = value * PI / 180

func setSpeed(value: float) -> void:
	speed = value

func clear_recent_hits() -> void:
	recent_hits = []

func find_enemies_to_focus() -> void:
	focused_entity = get_tree().get_nodes_in_group("Player").pop_front()
	if (!focused_entity):
		focused_entity = get_tree().get_nodes_in_group("Player_Minion").pop_front()

func hit_RHand() -> void:
	if !$Body/RHand.monitoring:
		return
	var bodies = $Body/RHand.get_overlapping_bodies() as Array[Entity]
	for body in bodies:
		if !recent_hits.has(body):
			recent_hits.append(body)
			if body.is_in_group("Player"):
				body.apply_damage(1)
				print("RHand Hit")
				break
func hit_LHand() -> void:
	if !$Body/LHand.monitoring:
		return
	var bodies = $Body/LHand.get_overlapping_bodies() as Array[Entity]
	for body in bodies:
		if !recent_hits.has(body):
			recent_hits.append(body)
			if body.is_in_group("Player"):
				body.apply_damage(1)
				print("LHand Hit")
				break

func fire(move: int) -> void:
	match move:
		0:
			for i in range(17):
				fireProjectile(position + Vector2(1,0).rotated(rotation) * 128, rotation + (i - 8)/17. * PI * 3 / 5, 200)
		1:
			for i in range(9):
				fireProjectile(Vector2(screenWidth * (i+1) / 10., 50), PI/2, 300)
			pass
		2:
			pass
		3:
			pass

func fireProjectile(pos: Vector2, angle: float, speed: float) -> void:
	var projectile = basic_projectile_object.instantiate()
	projectile.add_collision_exception_with(self)

	var area = get_tree().get_first_node_in_group("Area")
	if (!area): 
		area = get_node("/root")
	area.add_child(projectile)
	
	projectile.rotation = angle
	projectile.position = pos
	velocity = Vector2(1, 0).rotated(angle) * speed
	
	projectiles.append({
		"projectile": projectile,
		"velocity": velocity,
		"time": 0
		})

func apply_damage(amount: int) -> void:
	hp = hp - amount
	health_bar.execute({"entity" = self, "max" = 200})
	
	if hp <= 0 : 
		print("a winner is you")
		self.queue_free()
		health_bar.queue_free()
