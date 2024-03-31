extends Ability
class_name Projectile

var projectiles := []
var effector_groups := []
var entity: Entity
var speed: float
var direction: Vector2
var damage: int
var duration := 1


var last_shot = INF

func add_effector_group(group: StringName):
	if(!effector_groups.has(group)):
		effector_groups.append(group)

func _physics_process(delta):
	last_shot += delta
	for i in projectiles:
		var p = i["projectile"] as CharacterBody2D
		var vel = i["velocity"]
		var damage = i["damage"]
		
		if i["time"] >= duration:
			p.queue_free()
			projectiles.erase(i)
			pass
		
		var collision = p.move_and_collide(vel * delta)
		if collision:
			var collider = collision.get_collider() as Entity
			for group in effector_groups:
				if collider.is_in_group(group):
						collider.apply_damage(damage)
						p.queue_free()
						projectiles.erase(i)
				p.add_collision_exception_with(collider)
		i["time"] += delta
