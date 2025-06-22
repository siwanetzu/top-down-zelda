class_name ChaseState extends State

func enter():
	print("Entering Chase State")
	# When entering the chase state, play the walk animation.
	character.get_node("AnimatedSprite2D").play("idle")


func physics_update(delta: float):
	# If the player reference is lost for any reason, go back to idle.
	if not character.player:
		character.get_node("StateMachine").transition_to("Idle")
		return

	# Check the distance to the player.
	var distance_to_player = character.global_position.distance_to(character.player.global_position)
	print("ChaseState: Distance to player: ", distance_to_player)

	# If in attack range, transition to the Attack state.
	if distance_to_player <= character.attack_range:
		character.get_node("StateMachine").transition_to("AttackState")
		return

	# Otherwise, move towards the player.
	var direction = character.global_position.direction_to(character.player.global_position)
	character.velocity = direction * character.speed
	print("ChaseState: Moving towards player with direction: ", direction)
