extends SceneObject

var maxTime: float = 0
var phase: int = 0

var recent_hits := []

func initialize(_args: Dictionary) -> void:
	maxTime = _args["time"]
	$Timer.wait_time = maxTime
	$Timer.start()
	scale = Vector2.ZERO
	phase = 1

func _process(delta: float) -> void:
	if (phase == 1):
		scale = Vector2.ONE * (1 - $Timer.time_left / maxTime)
		if ($Timer.is_stopped()):
			$Timer.wait_time = 0.2
			$Timer.start()
			phase = 2
			$Sprite2D.modulate.a = 1
	if (phase == 2):
		if ($Timer.is_stopped()):
			self.queue_free()
		else:
			var bodies = $Area2D.get_overlapping_bodies() as Array[Entity]
			for body in bodies:
				if !recent_hits.has(body):
					recent_hits.append(body)
					if body.is_in_group("Player"):
						body.apply_damage(1)
						print("Explosion Hit")
						break
