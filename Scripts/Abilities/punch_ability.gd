extends Ability

var damage : int

func execute(args: Dictionary) -> void:
	var entity = args["entity"] as Entity
	local_cooldown = args["cooldown"] as float
	var damage = args["damage"] as int



func _ready():
	pass # Replace with function body.

func _process(delta):
	pass


func _on_body_entered(body):
	print(damage)
	body.apply_damage(damage)
