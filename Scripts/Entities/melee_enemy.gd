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
	self.hp = 15
	add_to_group("Enemy")
	
	
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
	
	if (self.position.distance_to(player.position) < 100):
		melee_ability.execute({"entity" = self,
								"at" = distance,
								"cooldown" = 1,
								"attack_rate" = 1,
								"range" = -10.00,
								"effectors" = ["Player"]})


func apply_damage(ammount: int) -> void:
	hp = hp -  ammount
	print("hp: ", hp)	
	
	if hp <= 0 : 
		print("dead")
		self.queue_free()

	
