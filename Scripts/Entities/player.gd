extends Entity
class_name Player


var move_ability := load_ability("move")
var dash_ability := load_ability("dash")
var basic_projectile_ability := load_ability("basic_projectile")
var melee_ability := load_ability("melee")
var health_bar : Ability

var tri_shot_ability := load_ability("tri_shot_projectile")

func _ready() -> void:
	#setup local vars
	self.hp = 2
	self.speed = 300
	add_to_group("Player")
	self.position = Vector2(575,325)
	
	dash_ability.level_up()
	
	health_bar = load_ability("healthBar")
	var freeNode = Node.new()
	add_child(freeNode)
	health_bar.reparent(freeNode)
	health_bar.global_position = Vector2(30, 30)
	health_bar.execute({"hp": hp})

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX = Input.get_axis("move_left", "move_right")
	var directionY = Input.get_axis("move_up", "move_down")
	var dir = Vector2(directionX, directionY).normalized()
	
	#cannot move while dashing
	if (!dash_ability.is_dashing()): move_ability.execute({"entity" = self, "speed" = self.speed, "direction" = dir})
	#velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#dash if we are not dashing and we are moving
	if (!dash_ability.is_dashing() and dir != Vector2.ZERO):
		if (Input.is_action_just_pressed("dash")):
			dash_ability.execute({"entity" = self, "speed" = self.speed*2, "duration" = 0.1})
			
	#projectile ability
	if(Input.is_action_pressed("attack")): basic_projectile_ability.execute(({"entity" = self, "speed" = 800, "direction" = get_local_mouse_position(), 
									"cooldown" = 1, "damage" = 5, "effectors" = ["Enemy"]}))
	
	
	# tripple projectile ability
	#if(Input.is_action_pressed("attack")): tri_shot_ability.execute(({"entity" = self, "speed" = 500, "direction" = get_local_mouse_position(), 
	#								"cooldown" = 1, "damage" = 5, "effectors" = ["Enemy"]}))
	
	
	#melee ability
	if(Input.is_action_pressed("attack")): melee_ability.execute({"entity" = self,
														"at" = get_global_mouse_position(),
														"cooldown" = 0.25,
														"attack_rate" = 1,
														"range" = 100.00,
														"effectors" = ["Enemy"]})

func apply_damage(amount: int) -> void:
	if (dash_ability.is_dashing()): return
	health_bar.execute({"hp":amount})
	hp -= amount
	if (hp <= 0):
		handle_death()

func handle_death() -> void:
	var parent = get_parent() as BaseArea
	match parent.area_ability:
		"Move":
			move_ability.level_up()	
		"Dash":
			dash_ability.level_up()
		"BasicRanged":
			basic_projectile_ability.level_up()
		"TriRanged":
			tri_shot_ability.level_up()
		_:
			pass
	#make parent signal an area load
	parent.query_area_load.emit(0)
	self.hp = 2
	health_bar.execute({"hp": hp})
	self.position = Vector2(575,325)
