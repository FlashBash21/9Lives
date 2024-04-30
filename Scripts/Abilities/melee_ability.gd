extends Ability

@onready var attack_player = $AttackPlayer
@onready var collision_area = $Area2D
@onready var attack_animation = $AnimatedSprite2D

var effector_groups := []
var recent_hits := []
var speed_multi := 1.0
var range := 10.0
var cd : float
var damage : int

func _ready():
	attack_animation.visible = false
	scale = Vector2.ONE * range / 5.

func execute(args: Dictionary) -> void:
	var entity := args["entity"] as Entity
	var at := args["at"] as Vector2
	cd = args["cooldown"] as float
	var attack_multi := args["attack_rate"] as float
	var effectors = args["effectors"] as Array[StringName]
	range = args["range"] as float
	damage = args["damage"] as int
	
	damage += (2*(level-1))
	effector_groups = effectors
	
	if level <=0: return
	if not attack_player.is_playing() and local_cooldown <= 0:
		local_cooldown = cd
		look_at(at)
		attack_player.speed_scale = attack_multi
		attack_player.play("attack", -1, 1)
		attack_animation.visible = true
		attack_animation.play()
		$AudioStreamPlayer.play()
		

func _process(delta):
	local_cooldown -= delta
	hit_entities_in_range()	


func _on_attack_player_animation_finished(anim_name):
	attack_animation.stop()
	attack_animation.visible = false
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
					body.apply_damage(damage)
					break

func clear_recent_hits() -> void:
	recent_hits = []
