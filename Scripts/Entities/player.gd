extends Entity
class_name Player

var print_ability := load_ability("print")
var move_ability := load_ability("move")
var dash_ability := load_ability("dash")
var basic_projectile_ability := load_ability("basic_projectile")
var melee_ability := load_ability("melee")

var tri_shot_ability := load_ability("tri_shot_projectile")

func _ready() -> void:
	#setup local vars
	self.hp = 15
	self.speed = 300
	add_to_group("Player")
	self.position = Vector2(575,325)
	print_ability.execute({})

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
		if (Input.is_action_just_pressed("dash")): dash_ability.execute({"entity" = self, "speed" = self.speed*2, "duration" = 0.1})
			
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
	
	
func apply_damage(ammount: int) -> void:
	hp = hp -  ammount
	print("hp: ", hp)	
	if (hp <= 0):
		var parent = get_parent() as BaseArea
		parent.query_area_load.emit(0)
		hp = 15
		self.position = Vector2(575,325)
		
