extends Ability

@onready var collision_area = $Area2D

var target_location : Vector2
var effector_groups := []
var speed : int
var entity : Entity
var min_range = 0

func execute(args: Dictionary) -> void:
	entity = args["entity"] as Entity
	var effectors = args["effectors"] as Array[StringName]
	var max_range = args["max_range"] as Vector2i
	min_range = args["min_range"] as float
	speed = args["speed"] as int
	
	effector_groups = effectors
	
	self.position = entity.position
	self.scale = max_range 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	spotted()
	moveTo()

func spotted():
	var bodies = collision_area.get_overlapping_bodies() as Array[Entity]
	#print(bodies)
	#print(collision_area.monitoring)
	for body in bodies:
		for group in effector_groups:
			if body.is_in_group(group):
					target_location = (body.position)
					return
	target_location = entity.position

func moveTo():
	entity.look_at(target_location)
	var direction = (target_location - entity.position)
	if (direction.length() != 0):	
		var distance = entity.position.distance_to(target_location)
		entity.velocity = direction.normalized() * speed
		if (distance < min_range):
			entity.velocity -= direction.normalized() * speed * 0.50
		
		if (distance > min_range + 1 || distance < min_range -1 ):
			entity.move_and_slide()	
			
