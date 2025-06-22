class_name ChaseState extends State

func enter():
	# When entering the chase state, play the walk/move animation.
	if character.animated_sprite.sprite_frames.has_animation("walk"):
		character.animated_sprite.play("walk")
	elif character.animated_sprite.sprite_frames.has_animation("idle"):
		character.animated_sprite.play("idle") # Fallback to idle

func physics_update(delta: float):
	# If the player reference is lost for any reason, go back to idle.
	if not character.player:
		character.state_machine.transition_to("IdleState")
		return

	# Check the distance to the player.
	var distance_to_player = character.global_position.distance_to(character.player.global_position)

	# If in attack range, transition to the Attack state.
	if distance_to_player <= character.attack_range:
		character.state_machine.transition_to("AttackState")
		return

	# Otherwise, move towards the player.
	var direction = character.global_position.direction_to(character.player.global_position)
	character.velocity = direction * character.speed