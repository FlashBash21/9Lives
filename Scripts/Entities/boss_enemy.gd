extends Entity

#the entity we are currently attacking
var focused_entity : Entity
#other entities we know about and may attack
var other_known_entities : Array[Entity]

func _ready():
	print("Hello World")
	add_to_group("Enemy")
	self.hp = 100
	focused_entity = null
	other_known_entities = []

func _process(delta):
	if (!focused_entity):
		if (other_known_entities.size() > 0):
			focused_entity = other_known_entities.pop_front()
		else:
			find_enemies_to_focus()

func find_enemies_to_focus() -> void:
	var player_entities = get_tree().get_nodes_in_group("Player")
	var minion_entities = get_tree().get_nodes_in_group("Player_Minion")
	
	
	focused_entity = player_entities.pop_front()
	other_known_entities.append_array(player_entities)
	if (!focused_entity):
		focused_entity = minion_entities.pop_front()
	other_known_entities.append_array(minion_entities)

func apply_damage(ammount: int) -> void:
	hp = hp -  ammount
	print("hp: ", hp)	
	
	if hp <= 0 : 
		print("dead")
		self.queue_free()
	
