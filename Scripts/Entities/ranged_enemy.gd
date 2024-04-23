extends Entity



var basic_projectile_ability := load_ability("basic_projectile")
var vision_ability := load_ability("ranged_vision")
var shoot_at = velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hp = 15
	add_to_group("Enemy")
	
	
	vision_ability.execute(({"entity" = self,
						"effectors" = ["Player"],
						"max_range" = self.scale * 200,
						"min_range" = 300,
						"speed" = 150}))			
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
		var player = get_tree().get_nodes_in_group("Player").pop_front()
		var shoot_at = player.position - self.position
		basic_projectile_ability.execute(({"entity" = self, "speed" = 500, "direction" = shoot_at, 
									"cooldown" = 2, "damage" = 1, "effectors" = ["Player"]}))
		

func apply_damage(ammount: int) -> void:
	hp = hp -  ammount
	print("hp: ", hp)	
	
	if hp <= 0 : 
		print("dead")
		self.queue_free()
