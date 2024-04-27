extends Ability

#var Lives = load("res://Scenes/Objects/lives.tscn")
@onready var label = $Label

func execute(args: Dictionary) -> void:
	var lives = args["life"] as int
	label.text = String.num(lives)

	
