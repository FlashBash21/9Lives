extends Entity

var punch_ability : Ability
var vision_ability := load_ability("vision")
# Called when the node enters the scene tree for the first time.
func _ready():
	punch_ability = load_ability("punch")
	self.hp = 15
	add_to_group("Enemy")
	punch_ability.execute({"entity" = self, 
					"attack_rate" = .5,
					"damage" = 1,
					"effectors" = ["Player"]})
	
	vision_ability.execute(({"entity" = self,
						"effectors" = ["Player"],
						"range" = self.scale * 20,
						"speed" = 100}))			
	#punch_ability.global_position = self.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass



func apply_damage(amount: int) -> void:
	hp = hp - amount
	print("hp: ", hp)	
	
	if hp <= 0 : 
		print("dead")
		self.queue_free()
