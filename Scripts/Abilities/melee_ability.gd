extends Ability

@onready var attack_player = $AttackPlayer
@onready var sprite = $ColorRect

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
	if not attack_player.is_playing() and local_cooldown <= 0:
		#entity.add_child(self)
		local_cooldown = cd
		position = Vector2.ZERO
		var dir := (at - to_global(position)).normalized()
		print(dir)
		look_at(at)
		position = dir * range
		attack_player.speed_scale = attack_multi
		attack_player.play("attack", -1, 1)

func _process(delta):
	local_cooldown -= delta


func _on_attack_player_animation_finished(anim_name):
	local_cooldown = cd
