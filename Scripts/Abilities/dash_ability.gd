extends Ability

@onready var dash_timer = $DashTimer
var entity: Entity
var speed: int
var duration: float
var dir: Vector2

func execute(args: Dictionary) -> void:
	if local_cooldown <= 0.5:
		return
	local_cooldown = 0
	entity = args["entity"] as Entity
	speed = args["speed"] as int
	duration = args["duration"] as float
	
	dir = entity.velocity.normalized()
	dash_timer.wait_time = duration
	dash_timer.start()

func _physics_process(delta):
	local_cooldown+=delta
	if is_dashing():
		entity.velocity = dir * speed
		entity.move_and_slide()

func is_dashing() -> bool:
	return !dash_timer.is_stopped()
