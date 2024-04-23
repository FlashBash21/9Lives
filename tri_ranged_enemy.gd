extends Entity
#class_name Enemy


var basic_projectile_ability := load_ability("tri_shot_projectile")
var vision_ability := load_ability("ranged_vision")
var shoot_at = velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hp = 15
	add_to_group("Enemy")
	
	
	vision_ability.execute(({"entity" = self,
						"effectors" = ["Player"],
						"range" = self.scale * 200,
						"speed" = 150}))			
	#punch_ability.global_position = self.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
		var player = get_tree().get_nodes_in_group("Player").pop_front()
		var shoot_at = player.position - self.position
		basic_projectile_ability.execute(({"entity" = self, "speed" = 400, "direction" = shoot_at, 
									"cooldown" = 2, "damage" = 1, "effectors" = ["Enemy"]}))
		#shoot_at = -shoot_at

func apply_damage(ammount: int) -> void:
	hp = hp -  ammount
	print("hp: ", hp)	
	
	if hp <= 0 : 
		print("dead")
		self.queue_free()
