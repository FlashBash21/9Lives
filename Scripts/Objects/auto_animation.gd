extends Node2D

@export var anim_name: String = ""

func _ready():
	$AnimationPlayer.queue(anim_name)
