extends Ability

@onready var label := $Label
@onready var panel := $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#self.position = Vector2(0,100)


func execute(args: Dictionary) -> void:
	var text := args["text"] as String
	var location := args["location"] as Vector2
	label.text = text
	panel.position = location
	label.position = location
	panel.visible = true
	label.visible = true
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	panel.visible = false
	label.visible = false
