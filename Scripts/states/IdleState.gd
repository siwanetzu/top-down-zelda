class_name IdleState extends State

func enter():
	print("Entering Idle State")
	# When entering the idle state, the character should stop moving
	# and play its idle animation.
	character.velocity = Vector2.ZERO
	character.get_node("AnimatedSprite2D").play("idle")
