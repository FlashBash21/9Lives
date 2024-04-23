extends Entity

var health_bar : Ability

var screenWidth = 1152
var screenHeight = 648

func _ready():
	self.hp = 200
	add_to_group("Enemy")
	
	health_bar = load_ability("Boss/healthBar")
	health_bar.reparent(get_tree().root)
	health_bar.global_position = Vector2(screenWidth/2., screenHeight - 50)
	
	rotation = 15

func apply_damage(amount: int) -> void:
	hp = hp - amount
	print("hp: ", hp)
	health_bar.execute({"entity" = self, "max" = 200})
	
	$AnimationPlayer.play("Punch")
	
	if hp <= 0 : 
		print("a winner is you")
		self.queue_free()
		health_bar.queue_free()
