extends Entity

var health_bar : Ability

var screenWidth = 1152
var screenHeight = 648

var focused_entity : Entity
var recent_hits := []
var tracking: float = 90 * PI / 180

var noAction = true
var actionCount = 0

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
	if (!focused_entity): return
	
	if (tracking > 0):
		var maxA = tracking * delta
		var da = get_angle_to(focused_entity.position)
		if (maxA > abs(da)):
			look_at(focused_entity.position)
		else:
			rotate(maxA * sign(da))
	
	if (speed > 0):
		velocity = Vector2(cos(rotation), sin(rotation)) * speed
		move_and_slide()

func nextAction() -> void:
	find_enemies_to_focus()
	noAction = !focused_entity
	if (noAction): return
	
	var distance = position.distance_to(focused_entity.position)
	
	if (actionCount >= 2):
		$AnimationPlayer.queue("Lunge")
		actionCount = 0
	else:
		$AnimationPlayer.queue("Punch")
		actionCount += 1

func setTracking(value: float) -> void:
	tracking = value * PI / 180

func setSpeed(value: float) -> void:
	speed = value

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

func clear_recent_hits() -> void:
	recent_hits = []

func apply_damage(amount: int) -> void:
	hp = hp - amount
	print("hp: ", hp)
	health_bar.execute({"entity" = self, "max" = 200})
	
	if hp <= 0 : 
		print("a winner is you")
		self.queue_free()
		health_bar.queue_free()
