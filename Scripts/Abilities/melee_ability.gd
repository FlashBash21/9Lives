extends Ability

@onready var attack_player = $AttackPlayer
@onready var sprite = $ColorRect
@onready var collision_area = $ColorRect/Area2D

var effector_groups := []
var recent_hits := []
var speed_multi := 1.0
var range := 100.0
var cd : float

func _ready():
	sprite.visible = false

func execute(args: Dictionary) -> void:
	var entity := args["entity"] as Entity
	var at := args["at"] as Vector2
	cd = args["cooldown"] as float
	var attack_multi := args["attack_rate"] as float
	var effectors = args["effectors"] as Array[StringName]
	
	effector_groups = effectors
	
	if not attack_player.is_playing() and local_cooldown <= 0:
		#entity.add_child(self)
		local_cooldown = cd
		position = Vector2.ZERO
		var dir := (at - to_global(position)).normalized()
		look_at(at)
		position = dir * range
		attack_player.speed_scale = attack_multi
		attack_player.play("attack", -1, 1)

func _process(delta):
	local_cooldown -= delta
	hit_entities_in_range()	


func _on_attack_player_animation_finished(anim_name):
	local_cooldown = cd


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
					print("melee hit")
					break

func clear_recent_hits() -> void:
	recent_hits = []
