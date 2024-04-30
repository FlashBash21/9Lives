extends Entity
class_name Player


var move_ability := load_ability("move")
var dash_ability := load_ability("dash")
var basic_projectile_ability := load_ability("basic_projectile")
var melee_ability := load_ability("melee")
var tri_shot_ability := load_ability("tri_shot_projectile")
var ability_text := load_ability("text")
var music := load_ability("music")
var health_bar : Ability
var lives : Ability
var maxhealth = 1
var nineLives = 9



func _ready() -> void:
	#setup local vars
	self.hp = maxhealth
	self.speed = 300
	add_to_group("Player")
	self.position = Vector2(575,325)
	
	health_bar = load_ability("healthBar")
	var healthNode = Node.new()
	add_child(healthNode)
	health_bar.reparent(healthNode)
	health_bar.global_position = Vector2(30, 30)
	health_bar.execute({"hp": hp})
	
	lives = load_ability("nine_lives")
	var lifeNode = Node.new()
	add_child(lifeNode)
	lives.reparent(lifeNode)
	lives.global_position = Vector2(1075, 5)
	lives.execute({"life": nineLives})

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX = Input.get_axis("move_left", "move_right")
	var directionY = Input.get_axis("move_up", "move_down")
	var dir = Vector2(directionX, directionY).normalized()
	
	
	
	
	#cannot move while dashing
	if (!dash_ability.is_dashing()): 
		move_ability.execute({"entity" = self, "speed" = self.speed, "direction" = dir})
		var look = self.position - self.get_last_motion()
		$SpriteBox.look_at(look)
	#velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#dash if we are not dashing and we are moving
	if (!dash_ability.is_dashing() and dir != Vector2.ZERO):
		if (Input.is_action_just_pressed("dash")):
			dash_ability.execute({"entity" = self, "speed" = self.speed*2, "duration" = 0.1})
			
	#projectile ability
	if(Input.is_action_pressed("attack")): basic_projectile_ability.execute(({"entity" = self, "speed" = 800, "direction" = get_local_mouse_position(),
									"cooldown" = 1, "damage" = 5, "effectors" = ["Enemy"]}))
	
	
	# tripple projectile ability
	if(Input.is_action_pressed("attack")): tri_shot_ability.execute(({"entity" = self, "speed" = 500, "direction" = get_local_mouse_position(),
									"cooldown" = 1, "damage" = 5, "effectors" = ["Enemy"]}))
	
	
	#melee ability
	if(Input.is_action_pressed("attack")): melee_ability.execute({"entity" = self,
														"at" = get_global_mouse_position(),
														"cooldown" = 0.25,
														"attack_rate" = 1,
														"range" = 10.00,
														"effectors" = ["Enemy"],
														"damage" = 5})

func apply_damage(amount: int) -> void:
	if (dash_ability.is_dashing()): return
	hp -= amount
	health_bar.execute({"hp":hp})
	$damage.play()
	if (hp <= 0):
		handle_death()

func handle_death() -> void:
	var parent = get_parent() as BaseArea
	var textCoords = Vector2(225,150)
	match parent.area_ability:
		"Move":
			move_ability.level_up()
			ability_text.execute({"text" = "+++ Movement Speed Increased +++", "location" = textCoords})
		"Dash":
			dash_ability.level_up()
			if(dash_ability.level == 1): 
				ability_text.execute({"text" = "+++ Dash Unlocked +++", "location" = textCoords})
			if(dash_ability.level > 1):
				ability_text.execute({"text" = "+++ Dash Upgraded +++", "location" = textCoords})
		"BasicRanged":
			basic_projectile_ability.level_up()
			if(basic_projectile_ability.level == 1): 
				ability_text.execute({"text" = "+++ Projectile Unlocked +++", "location" = textCoords})
			if(basic_projectile_ability.level > 1):
				ability_text.execute({"text" = "+++ Projectile Upgraded +++", "location" = textCoords})
		"Health":
			maxhealth += 1
			ability_text.execute({"text" = "+++ Health Increased +++", "location" = textCoords})
		"TriRanged":
			tri_shot_ability.level_up()
			if(tri_shot_ability.level == 1): 
				ability_text.execute({"text" = "+++ Triple Shot Unlocked +++", "location" = textCoords})
			if(tri_shot_ability.level > 1):
				ability_text.execute({"text" = "+++ Triple Shot Upgraded +++", "location" = textCoords})
		"Melee":
			melee_ability.level_up()
			if(melee_ability.level == 1): 
				ability_text.execute({"text" = "+++ Melee Unlocked +++", "location" = textCoords})
			if(melee_ability.level > 1):
				ability_text.execute({"text" = "+++ Melee Upgraded +++", "location" = textCoords})
		_:
			pass
	#make parent signal an area load
	parent.query_area_load.emit(0)
	music.execute({"melody_melee" = melee_ability.level,
				   "bass_dash" = dash_ability.level, 
				   "vibe_basicProjectile" = basic_projectile_ability.level,
				   "basic16th_tripleProjectile" = tri_shot_ability.level,
				   "keys_movement" = move_ability.level	})
	self.hp = maxhealth
	health_bar.execute({"hp": hp})
	self.position = Vector2(575,325)
	nineLives -= 1
	lives.execute(({"life" : nineLives}))
	if nineLives <= 0:
		handle_perma_death()
		
func handle_perma_death() -> void:
	self.queue_free()
	health_bar.queue_free()
	get_tree().change_scene_to_file("res://Scenes/LoseScreen.tscn")
