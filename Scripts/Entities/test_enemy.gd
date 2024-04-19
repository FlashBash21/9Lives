extends Entity

var punch := load_ability("punch")
# Called when the node enters the scene tree for the first time.
func _ready():
	self.hp = 15
	punch.execute({"entity" = self, "cooldown" = 1, "damage" = 5 })
	add_to_group("Enemy")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func apply_damage(ammount: int) -> void:
	hp = hp -  ammount
	print("hp: ", hp)	
	
	if hp <= 0 : 
		print("dead")
		self.queue_free()
	
