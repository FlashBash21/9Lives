extends Entity

var basic_projectile_object = load("res://Scenes/Objects/basic_projectile_object.tscn")
var explosion_object = load("res://Scenes/Objects/delayed_explosion.tscn")
var afterimage = load("res://Scenes/Objects/boss_afterimage.tscn")

var health_bar : Ability

var screenWidth = 1152
var screenHeight = 648

var focused_entity : Entity
var recent_hits := []
var tracking: float = 90 * PI / 180
var healthRate: float = 1
var cameraShake: float = 0

var projectiles := []

var noAction = true
var actionCount = 0
var zoneCount = 0
var nextHand = -1
var phase:int
var phaseStep: int

func _ready():
	self.hp = 1
	add_to_group("Enemy")
	
	health_bar = load_ability("Boss/healthBar")
	var freeNode = Node.new()
	add_child(freeNode)
	health_bar.reparent(freeNode)
	health_bar.global_position = Vector2(screenWidth/2., screenHeight - 50)
	
	focused_entity = null
	speed = 0
	phase = 1

func _process(delta: float) -> void:
	if (noAction): nextAction()
	hit_RHand()
	hit_LHand()
	if (speed > 1000):
		var image = afterimage.instantiate()
		image.position = position
		image.rotation = rotation
		addToArea(image)
	if (cameraShake > 0):
		cameraShake -= delta
		if (cameraShake <= 0):
			cameraShake = 0
			get_viewport().get_camera_2d().offset = Vector2.ZERO
		else:
			var r = cameraShake * 50 * sin(PI * cameraShake * 20)
			var a = 4 * PI * cameraShake
			get_viewport().get_camera_2d().offset = Vector2(r * cos(a), r * sin(a))

func _physics_process(delta: float) -> void:
	for bullet in projectiles:
		var p = bullet["projectile"] as CharacterBody2D
		var vel = bullet["velocity"]
		
		if bullet["time"] >= 5:
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
	
	if (phaseStep == 1):
		var maxA = PI * delta
		var da = get_angle_to(Vector2(screenWidth,screenHeight)/2.)
		if (maxA > abs(da)):
			look_at(Vector2(screenWidth,screenHeight)/2.)
		else:
			rotate(maxA * sign(da))
	elif (phaseStep == 5):
		var maxA = PI * delta
		var da = PI/2 - rotation
		if (maxA > abs(da)):
			rotate(da)
		else:
			rotate(maxA * sign(da))
	elif (tracking > 0):
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
	healthRate = 1
	noAction = !focused_entity
	if (noAction): return
	
	if (actionCount < 0):
		print("Queue: ",-actionCount)
		actionCount += 1
		return
	
	var distance = position.distance_to(focused_entity.position)
	
	if (hp < 120 and phase == 1):
		phase = 2
		$AnimationPlayer.queue("PhaseChange")
		$AnimationPlayer.queue("Lunge2")
		actionCount = -1
		zoneCount = 0
		nextHand = -1
		return
	
	if (phase == 2):
		if (zoneCount >= 5):
			$AnimationPlayer.queue("Zone_3")
			$AnimationPlayer.queue("Lunge2")
			actionCount = -1
			zoneCount = 0
			nextHand = -1
			return
		else:
			zoneCount += 1
	
	if (actionCount >= 2):
		$AnimationPlayer.queue("Lunge2" if phase == 2 else "Lunge")
		actionCount = 0
		nextHand = -1
	elif distance < 300:
		if nextHand < 0:
			nextHand = randi() % 2
			$AnimationPlayer.queue((["PunchR2","PunchL2"] if phase == 2 else ["PunchR","PunchL"])[1-nextHand])
		else:
			$AnimationPlayer.queue((["PunchR2","PunchL2"] if phase == 2 else ["PunchR","PunchL"])[nextHand])
		actionCount += 1
	else:
		$AnimationPlayer.queue("Slam")
		actionCount += 2

func setTracking(value: float) -> void:
	tracking = value * PI / 180

func setSpeed(value: float) -> void:
	speed = value

func setHealthRate(value: float) -> void:
	healthRate = value

func shakeCamera(value: float) -> void:
	cameraShake = value

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
			if phase == 2:
				for i in range(3):
					fireProjectile(position + Vector2(1,0).rotated(rotation) * 128, rotation + (i - 1)/3. * PI / 2., 400)
		1:
			for i in range(9):
				fireProjectile(Vector2(screenWidth * (i+1) / 10., 50), PI/2, 300)
		2:
			pass
		3:
			for i in range(30):
				var explosion = explosion_object.instantiate() as SceneObject
				addToArea(explosion)
				explosion.position = Vector2(screenWidth * randf_range(0.1,0.9), screenHeight * randf_range(0,1))
				explosion.initialize({"time": 3 + i / 10.})

func fireProjectile(pos: Vector2, angle: float, speed: float) -> void:
	var projectile = basic_projectile_object.instantiate()
	projectile.add_collision_exception_with(self)

	addToArea(projectile)
	
	projectile.rotation = angle
	projectile.position = pos
	velocity = Vector2(1, 0).rotated(angle) * speed
	
	projectiles.append({
		"projectile": projectile,
		"velocity": velocity,
		"time": 0
		})

func phaseChange(step: int) -> void:
	phaseStep = step
	match step:
		1: # Turn to Center
			setHealthRate(0.2)
			setTracking(0)
		2: # Stop Turning
			pass
		3: # Dash to Center
			setSpeed(position.distance_to(Vector2(screenWidth,screenWidth)/2.)*2)
		4: # Stop Dashing
			setSpeed(0)
			position = Vector2(screenWidth, screenHeight)/2.
		5: # Turn to bottom
			pass
		6: # Stop Turning
			clear_recent_hits()
		7:
			setTracking(90)
			nextAction()

func addToArea(obj: Node) -> void:
	var area = get_tree().get_first_node_in_group("Area")
	if (!area): 
		area = get_node("/root")
	area.add_child(obj)

func apply_damage(amount: int) -> void:
	hp = hp - amount * healthRate
	health_bar.execute({"entity" = self, "max" = 200})
	
	if hp <= 0 :
		self.queue_free()
		health_bar.queue_free()
		for bullet in projectiles:
			(bullet["projectile"] as CharacterBody2D).queue_free()
		get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")
