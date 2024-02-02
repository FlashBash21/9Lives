extends Entity

const PRINT_ABILITY := preload("res://Scenes/Abilities/print_ability.tscn")
const MOVE_ABILITY := preload("res://Scenes/Abilities/move_ability.tscn")

var print_ability := PRINT_ABILITY.instantiate()
var move_ability := MOVE_ABILITY.instantiate()

func _ready() -> void:
	#setup local vars
	self.speed = 500

	print_ability.execute({})
func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX = Input.get_axis("move_left", "move_right")
	var directionY = Input.get_axis("move_up", "move_down")
	var dir = Vector2(directionX, directionY).normalized()
	
	move_ability.execute({"entity" = self, "speed" = self.speed, "direction" = dir})
	#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
