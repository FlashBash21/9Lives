extends Ability

func execute(args: Dictionary) -> void:
	var hp = args["hp"] as int
	var count = get_child_count()
	if (count > hp):
		while (count > hp && count > 0):
			count -= 1
			remove_child(get_child(count))
	elif (count < hp):
		for i in range(count, hp):
			var newHeart = $Heart.duplicate()
			newHeart.position = Vector2(i * 50, 0)
			add_child(newHeart)
