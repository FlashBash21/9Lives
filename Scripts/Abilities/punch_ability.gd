extends Ability

@onready var collision_area = $Area2D
@onready var attack_player = $AttackPlayer

var effector_groups := []
var recent_hits := []
var attack_multi := 1.0
var damage: int



func execute(args: Dictionary) -> void:
	var entity = args["entity"] as Entity
	damage = args["damage"] as int
	var effectors = args["effectors"] as Array[StringName]
	attack_multi = args["attack_rate"] as float
	
	effector_groups = effectors
	self.position = entity.position
	self.scale = entity.scale
	attack_player.speed_scale = attack_multi
	

func _process(delta):
	attack_player.play("new_animation", -1, 1)
	hit_entities_in_range()


func hit_entities_in_range() -> void:
	if !collision_area.monitoring:
		return
	var bodies = collision_area.get_overlapping_bodies() as Array[Entity]
	for body in bodies:
		if !recent_hits.has(body):
			recent_hits.append(body)
			for group in effector_groups:
				if body.is_in_group(group):
					body.apply_damage(5)
					print("punch hit")
					break


func clear_recent_hits() -> void:
	recent_hits = []
