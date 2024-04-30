extends Entity


var ranged_vision_ability := load_ability("ranged_vision")
var dash_ability := load_ability("dash")
var melee_ability := load_ability("melee")
@onready var dash_time = $Timer

var player
var once = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.speed = 100
	dash_time.start()
	dash_ability.level_up()
	self.hp = 15
	add_to_group("Enemy")
	melee_ability.level_up()
	
	ranged_vision_ability.execute(({"entity" = self,
						"effectors" = ["Player"],
						"max_range" = self.scale * 200,
						"min_range" = 90,
						"speed" = self.speed}))			
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(once):
		player = get_tree().get_nodes_in_group("Player").pop_front()
		once = false
	var distance = (to_local(player.position) - to_local(self.position))
	look_at((distance))
	
	if (self.position.distance_to(player.position) < 100 && !dash_ability.is_dashing()):
		melee_ability.execute({"entity" = self,
								"at" = distance,
								"cooldown" = 1,
								"attack_rate" = 1,
								"range" = -10.00,
								"damage" = 1,
								"effectors" = ["Player"]})



func apply_damage(ammount: int) -> void:
	hp = hp -  ammount
	print("hp: ", hp)	
	$damage.play()
	
	if hp <= 0 : 
		print("dead")
		self.queue_free()


func _dodge():
	var i = 1
	
	if (randi_range(0,1) == 0):
		i = -1
	randomize()
	var rotate_dir = deg_to_rad(randi_range(0,90))
	var direction = self.velocity.rotated(rotate_dir)
	self.velocity = direction.normalized() * speed
	if (!dash_ability.is_dashing() and self.velocity != Vector2.ZERO):
		print("dash")
		dash_ability.execute({"entity" = self, "speed" = self.speed*2, "duration" = 0.4})
	dash_time.start()
	
